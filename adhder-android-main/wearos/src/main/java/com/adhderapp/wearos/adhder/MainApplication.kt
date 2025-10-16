package com.adhderapp.wearos.adhder

import android.app.Application
import android.content.Intent
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.crashlytics.ktx.crashlytics
import com.google.firebase.ktx.Firebase
import com.adhderapp.android.adhder.BuildConfig
import com.adhderapp.common.adhder.extensions.setupCoil
import com.adhderapp.common.adhder.helpers.MarkdownParser
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.ui.activities.BaseActivity
import com.adhderapp.wearos.adhder.ui.activities.FaintActivity
import com.adhderapp.wearos.adhder.ui.activities.LoginActivity
import com.adhderapp.wearos.adhder.ui.activities.MainActivity
import com.adhderapp.wearos.adhder.ui.activities.RYAActivity
import dagger.hilt.android.HiltAndroidApp
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject
import kotlin.time.DurationUnit
import kotlin.time.toDuration

@HiltAndroidApp
class MainApplication : Application() {
    @Inject lateinit var userRepository: UserRepository

    @Inject lateinit var taskRepository: TaskRepository

    override fun onCreate() {
        super.onCreate()
        MarkdownParser.setup(this)
        setupCoil()
        setupFirebase()

        MainScope().launch {
            userRepository.getUser()
                .filterNotNull()
                .onEach {
                    if (it.isDead && BaseActivity.currentActivityClassName == MainActivity::class.java.name) {
                        val intent = Intent(this@MainApplication, FaintActivity::class.java)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                    } else if (it.needsCron && BaseActivity.currentActivityClassName != RYAActivity::class.java.name && BaseActivity.currentActivityClassName != LoginActivity::class.java.name) {
                        val intent = Intent(this@MainApplication, RYAActivity::class.java)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                    }
                    delay(1.toDuration(DurationUnit.SECONDS))
                }.collect()
        }

        logLaunch()
    }

    private fun logLaunch() {
        if (!BuildConfig.DEBUG) {
            Firebase.analytics.logEvent("wear_launched", null)
        }
    }

    private fun setupFirebase() {
        if (!BuildConfig.DEBUG) {
            val crashlytics = Firebase.crashlytics
            if (userRepository.hasAuthentication) {
                crashlytics.setUserId(userRepository.userID)
            }
            crashlytics.setCustomKey("is_wear", true)
            FirebaseAnalytics.getInstance(this).setUserProperty("app_testing_level", BuildConfig.TESTING_LEVEL)
        }
    }
}
