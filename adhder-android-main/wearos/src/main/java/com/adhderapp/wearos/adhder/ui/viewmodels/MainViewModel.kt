package com.adhderapp.wearos.adhder.ui.viewmodels

import androidx.lifecycle.asLiveData
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.Date
import javax.inject.Inject
import kotlin.time.DurationUnit
import kotlin.time.toDuration

@HiltViewModel
class MainViewModel
@Inject
constructor(
    userRepository: UserRepository,
    taskRepository: TaskRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager) {
    private var lastUserFetch = 0L

    fun periodicUserRefresh() {
        val now = Date().time
        if ((now - lastUserFetch) > 5.toDuration(DurationUnit.MINUTES).inWholeMilliseconds) {
            retrieveFullUserData()
            lastUserFetch = now
        }
    }

    val taskCounts = taskRepository.getActiveTaskCounts().asLiveData()
    val user = userRepository.getUser()
}
