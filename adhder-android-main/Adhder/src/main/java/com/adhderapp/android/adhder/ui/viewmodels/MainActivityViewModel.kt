package com.adhderapp.android.adhder.ui.viewmodels

import android.content.SharedPreferences
import androidx.compose.runtime.mutableStateOf
import androidx.core.content.edit
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.api.MaintenanceApiService
import com.adhderapp.android.adhder.data.ContentRepository
import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.helpers.Analytics
import com.adhderapp.android.adhder.helpers.EventCategory
import com.adhderapp.android.adhder.helpers.HitType
import com.adhderapp.android.adhder.helpers.TaskAlarmManager
import com.adhderapp.android.adhder.helpers.notifications.PushNotificationManager
import com.adhderapp.android.adhder.models.TutorialStep
import com.adhderapp.android.adhder.models.inventory.Egg
import com.adhderapp.android.adhder.ui.TutorialView
import com.adhderapp.common.adhder.api.HostConfig
import com.adhderapp.common.adhder.helpers.ExceptionHandler
import com.adhderapp.common.adhder.helpers.launchCatching
import com.adhderapp.shared.adhder.models.responses.MaintenanceResponse
import dagger.hilt.android.lifecycle.HiltViewModel
import io.realm.kotlin.isValid
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.launch
import java.util.Date
import javax.inject.Inject

@HiltViewModel
class MainActivityViewModel
@Inject
constructor(
    userRepository: UserRepository,
    userViewModel: MainUserViewModel,
    val hostConfig: HostConfig,
    val pushNotificationManager: PushNotificationManager,
    val sharedPreferences: SharedPreferences,
    val contentRepository: ContentRepository,
    val taskRepository: TaskRepository,
    val inventoryRepository: InventoryRepository,
    val taskAlarmManager: TaskAlarmManager,
    val maintenanceService: MaintenanceApiService
) : BaseViewModel(userRepository, userViewModel), TutorialView.OnTutorialReaction {
    val isAuthenticated: Boolean
        get() = hostConfig.hasAuthentication()
    val launchScreen: String?
        get() = sharedPreferences.getString("launch_screen", "")
    var preferenceLanguage: String?
        get() = sharedPreferences.getString("language", "en")
        set(value) {
            sharedPreferences.edit {
                putString("language", value)
            }
        }
    var requestNotificationPermission = MutableLiveData(false)

    val canShowTeamPlanHeader = mutableStateOf(false)

    override fun onCleared() {
        taskRepository.close()
        inventoryRepository.close()
        contentRepository.close()
        super.onCleared()
    }

    fun onCreate() {
        try {
            viewModelScope.launch(ExceptionHandler.coroutine()) {
                taskAlarmManager.scheduleAllSavedAlarms(
                    sharedPreferences.getBoolean(
                        "preventDailyReminder",
                        false
                    )
                )
            }
        } catch (e: Exception) {
            Analytics.logException(e)
        }
    }

    fun onResume() {
        // Track when the app was last opened, so that we can use this to send out special reminders after a week of inactivity
        sharedPreferences.edit {
            putLong("lastAppLaunch", Date().time)
            putBoolean("preventDailyReminder", false)
        }
    }

    fun retrieveUser(forced: Boolean = false) {
        if (hostConfig.hasAuthentication()) {
            viewModelScope.launch(ExceptionHandler.coroutine()) {
                contentRepository.retrieveWorldState()
                userRepository.retrieveUser(true, forced)?.let { user ->
                    Analytics.setUserProperty(
                        "has_party",
                        if (user.party?.id?.isNotEmpty() == true) "true" else "false"
                    )
                    Analytics.setUserProperty(
                        "is_subscribed",
                        if (user.isSubscribed) "true" else "false"
                    )
                    Analytics.setUserProperty(
                        "checkin_count",
                        user.loginIncentives.toString()
                    )
                    user.preferences?.pushNotifications?.mapOfKeys()?.forEach { key, isEnabled ->
                        Analytics.setUserProperty("allow_push_${key}", isEnabled)
                    }
                    Analytics.setUserProperty("level", user.stats?.lvl?.toString() ?: "")
                    pushNotificationManager.setUser(user)
                    if (!pushNotificationManager.notificationPermissionEnabled()) {
                        if (sharedPreferences.getBoolean("usePushNotifications", true)) {
                            requestNotificationPermission.value = true
                        }
                    } else {
                        pushNotificationManager.addPushDeviceUsingStoredToken()
                    }
                }
                inventoryRepository.retrieveInAppRewards()
                contentRepository.retrieveContent()
            }
            viewModelScope.launchCatching {
                userRepository.retrieveTeamPlans()
            }
        }
    }

    fun updateAllowPushNotifications(allowPushNotifications: Boolean) {
        sharedPreferences.getBoolean("usePushNotifications", true)
        sharedPreferences.edit {
            putBoolean("usePushNotifications", allowPushNotifications)
        }
    }

    override fun onTutorialCompleted(step: TutorialStep) {
        updateUser("flags.tutorial." + step.tutorialGroup + "." + step.identifier, true)
        logTutorialStatus(step, true)
    }

    override fun onTutorialDeferred(step: TutorialStep) {
        taskRepository.modify(step) { it.displayedOn = Date() }
    }

    fun logTutorialStatus(
        step: TutorialStep,
        complete: Boolean
    ) {
        val additionalData = HashMap<String, Any>()
        additionalData["eventLabel"] = step.identifier + "-android"
        additionalData["eventValue"] = step.identifier ?: ""
        additionalData["complete"] = complete
        Analytics.sendEvent(
            "tutorial",
            EventCategory.BEHAVIOUR,
            HitType.EVENT,
            additionalData
        )
    }

    fun ifNeedsMaintenance(onResult: ((MaintenanceResponse) -> Unit)) {
        viewModelScope.launchCatching {
            val maintenanceResponse = maintenanceService.getMaintenanceStatus()
            if (maintenanceResponse?.activeMaintenance == null) {
                return@launchCatching
            }
            onResult(maintenanceResponse)
        }
    }

    fun getToolbarTitle(
        id: Int,
        label: CharSequence?,
        eggType: String?,
        onSuccess: ((CharSequence?) -> Unit)
    ) {
        if (id == R.id.petDetailRecyclerFragment || id == R.id.mountDetailRecyclerFragment) {
            viewModelScope.launchCatching {
                val item = inventoryRepository.getItem("egg", eggType ?: "").firstOrNull()
                if (item?.isValid() != true) return@launchCatching
                onSuccess(
                    if (id == R.id.petDetailRecyclerFragment) {
                        (item as? Egg)?.text
                    } else {
                        (item as? Egg)?.mountText
                    }
                )
            }
        } else {
            onSuccess(
                if (id == R.id.promoInfoFragment) {
                    ""
                } else if (label.isNullOrEmpty() && user.value?.isValid == true) {
                    user.value?.profile?.name
                } else {
                    label ?: ""
                }
            )
        }
    }
}
