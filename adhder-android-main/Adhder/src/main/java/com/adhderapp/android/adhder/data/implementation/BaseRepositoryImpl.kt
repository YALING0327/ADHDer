package com.adhderapp.android.adhder.data.implementation

import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.BaseRepository
import com.adhderapp.android.adhder.data.local.BaseLocalRepository
import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.android.adhder.modules.AuthenticationHandler

abstract class BaseRepositoryImpl<T : BaseLocalRepository>(
    protected val localRepository: T,
    protected val apiClient: ApiClient,
    protected val authenticationHandler: AuthenticationHandler
) : BaseRepository {
    val currentUserID: String
        get() = authenticationHandler.currentUserID ?: ""

    override fun close() {
        this.localRepository.close()
    }

    override fun <T : BaseObject> getUnmanagedCopy(list: List<T>): List<T> {
        return localRepository.getUnmanagedCopy(list)
    }

    override val isClosed: Boolean
        get() = localRepository.isClosed

    override fun <T : BaseObject> getUnmanagedCopy(obj: T): T {
        return localRepository.getUnmanagedCopy(obj)
    }
}
