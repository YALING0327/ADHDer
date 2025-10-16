package com.adhderapp.wearos.adhder.ui.viewmodels

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.asLiveData
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class TaskDetailViewModel
@Inject
constructor(
    savedStateHandle: SavedStateHandle,
    taskRepository: TaskRepository,
    userRepository: UserRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager) {
    val taskID = savedStateHandle.get<String>("task_id")
    val task = taskRepository.getTask(taskID).asLiveData()
}
