package com.adhderapp.wearos.adhder.ui.viewmodels

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.adhderapp.wearos.adhder.data.repositories.TaskRepository
import com.adhderapp.wearos.adhder.data.repositories.UserRepository
import com.adhderapp.wearos.adhder.managers.AppStateManager
import com.adhderapp.wearos.adhder.models.DisplayedError
import com.adhderapp.wearos.adhder.util.ErrorPresenter
import com.adhderapp.wearos.adhder.util.ExceptionHandlerBuilder
import kotlinx.coroutines.launch

open class BaseViewModel(
    val userRepository: UserRepository,
    val taskRepository: TaskRepository,
    val exceptionBuilder: ExceptionHandlerBuilder,
    val appStateManager: AppStateManager
) : ViewModel(), ErrorPresenter {
    override val errorValues = MutableLiveData<DisplayedError>()

    fun retrieveFullUserData() {
        viewModelScope.launch(exceptionBuilder.userFacing(this)) {
            appStateManager.startLoading()
            val user = userRepository.retrieveUser(true)
            taskRepository.retrieveTasks(user?.tasksOrder, true)
            appStateManager.endLoading()
        }
    }
}
