package com.adhderapp.wearos.adhder.ui.viewmodels

import com.adhderapp.shared.adhder.models.tasks.Frequency
import com.adhderapp.shared.adhder.models.tasks.TaskType
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.models.tasks.Task
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class TaskFormViewModel
@Inject
constructor(
    userRepository: UserRepository,
    taskRepository: TaskRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager) {
    suspend fun saveTask(
        text: CharSequence?,
        taskType: TaskType?
    ) {
        if (text?.isNotBlank() != true || taskType == null) {
            return
        }
        val task = Task()
        task.text = text.toString()
        task.type = taskType
        task.priority = 1.0f
        task.up = true
        task.everyX = 1
        task.frequency = Frequency.DAILY
        taskRepository.createTask(task)
    }
}
