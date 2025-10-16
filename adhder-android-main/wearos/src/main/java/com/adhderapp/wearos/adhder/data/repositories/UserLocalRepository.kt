package com.adhderapp.wearos.adhder.data.repositories

import com.adhderapp.wearos.adhder.models.user.User
import kotlinx.coroutines.flow.MutableStateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UserLocalRepository
@Inject
constructor() {
    private val user = MutableStateFlow<User?>(null)

    fun getUser() = user

    fun saveUser(user: User) {
        this.user.value = user
    }

    fun clearData() {
        user.value = null
    }
}
