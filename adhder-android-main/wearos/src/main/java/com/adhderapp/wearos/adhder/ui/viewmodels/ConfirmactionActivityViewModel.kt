package com.adhderapp.wearos.adhder.ui.viewmodels

import androidx.lifecycle.SavedStateHandle
import com.adhderapp.android.adhder.R
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class ConfirmactionActivityViewModel
@Inject
constructor(
    savedStateHandle: SavedStateHandle,
    userRepository: UserRepository,
    taskRepository: TaskRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager) {
    val icon: Int = savedStateHandle["icon"] ?: R.drawable.error
    val text: String? = savedStateHandle["text"]
}
