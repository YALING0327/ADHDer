package com.adhderapp.wearos.adhder.ui.viewmodels

import android.content.SharedPreferences
import androidx.core.content.edit
import androidx.lifecycle.viewModelScope
import com.adhderapp.wearos.adhder.data.ApiClient
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel
@Inject
constructor(
    userRepository: UserRepository,
    taskRepository: TaskRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    private val apiClient: ApiClient,
    private val sharedPreferences: SharedPreferences,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager) {
    fun logout() {
        sharedPreferences.edit {
            clear()
        }
        apiClient.updateAuthenticationCredentials(null, null)
        userRepository.clearData()
        taskRepository.clearData()
    }

    fun resyncData() {
        viewModelScope.launch(exceptionBuilder.userFacing(this)) {
            appStateManager.startLoading()
            val user = userRepository.retrieveUser(true)
            taskRepository.retrieveTasks(user?.tasksOrder, true)
            appStateManager.endLoading()
        }
    }

    fun setHideTaskResults(hide: Boolean) {
        sharedPreferences.edit {
            putBoolean("hide_task_results", hide)
        }
    }

    fun isTaskResultHidden(): Boolean {
        return sharedPreferences.getBoolean("hide_task_results", false)
    }
}
