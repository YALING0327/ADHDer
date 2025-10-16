package com.adhderapp.wearos.adhder.ui.viewmodels

import androidx.lifecycle.SavedStateHandle
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class ContinuePhoneViewModel
@Inject
constructor(
    savedStateHandle: SavedStateHandle,
    userRepository: UserRepository,
    taskRepository: TaskRepository,
    exceptionBuilder: ExceptionHandlerBuilder,
    appStateManager: AppStateManager
) : BaseViewModel(userRepository, taskRepository, exceptionBuilder, appStateManager), MessageClient.OnMessageReceivedListener {
    val keepActive = savedStateHandle.get<Boolean>("keep_active") ?: false
    var onActionCompleted: (() -> Unit)? = null

    override fun onMessageReceived(event: MessageEvent) {
        when (event.path) {
            "/action_completed" -> onActionCompleted?.invoke()
        }
    }
}
