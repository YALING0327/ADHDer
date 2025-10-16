package com.adhderapp.android.adhder.modules

import android.content.Context
import android.content.SharedPreferences
import com.adhderapp.android.adhder.data.SocialRepository
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.helpers.TaskAlarmManager
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.filterNotNull
import javax.inject.Singleton

class AuthenticationHandler {
    fun updateUserID(userID: String) {
        _userIDFlow.value = userID
    }

    private val _userIDFlow = MutableStateFlow<String?>(null)
    val userIDFlow: Flow<String> = _userIDFlow.filterNotNull()

    val currentUserID: String?
        get() = _userIDFlow.value

    val isAuthenticated: Boolean
        get() = currentUserID != null

    constructor(sharedPreferences: SharedPreferences) {
        _userIDFlow.value = sharedPreferences.getString("UserID", "") ?: ""
    }

    constructor(userID: String) {
        _userIDFlow.value = userID
    }
}

@InstallIn(SingletonComponent::class)
@Module
class UserModule {
    @Provides
    fun providesTaskAlarmManager(
        @ApplicationContext context: Context,
        taskRepository: TaskRepository,
        authenticationHandler: AuthenticationHandler
    ): TaskAlarmManager {
        return TaskAlarmManager(context, taskRepository, authenticationHandler)
    }

    @Provides
    @Singleton
    fun providesUserViewModel(
        authenticationHandler: AuthenticationHandler,
        userRepository: UserRepository,
        socialRepository: SocialRepository
    ) = MainUserViewModel(authenticationHandler, userRepository, socialRepository)
}
