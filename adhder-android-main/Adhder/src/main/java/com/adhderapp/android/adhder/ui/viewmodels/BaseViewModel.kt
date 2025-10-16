package com.adhderapp.android.adhder.ui.viewmodels

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.common.adhder.helpers.ExceptionHandler
import kotlinx.coroutines.launch

abstract class BaseViewModel(
    val userRepository: UserRepository,
    val userViewModel: MainUserViewModel
) : ViewModel() {
    val user: LiveData<User?> by lazy {
        userViewModel.user
    }

    override fun onCleared() {
        userRepository.close()
        super.onCleared()
    }

    fun updateUser(
        path: String,
        value: Any
    ) {
        viewModelScope.launch(ExceptionHandler.coroutine()) {
            userRepository.updateUser(path, value)
        }
    }
}
