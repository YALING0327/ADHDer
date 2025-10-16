package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.BaseMainObject
import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.android.adhder.models.user.User
import io.realm.Realm

interface BaseLocalRepository {
    val isClosed: Boolean
    var realm: Realm

    fun close()

    fun executeTransaction(transaction: (Realm) -> Unit)

    fun <T : BaseMainObject> modify(
        obj: T,
        transaction: (T) -> Unit
    )

    fun <T : BaseObject> getLiveObject(obj: T): T?

    fun <T : BaseObject> getUnmanagedCopy(managedObject: T): T

    fun <T : BaseObject> getUnmanagedCopy(list: List<T>): List<T>

    fun <T : BaseObject> save(objects: List<T>)

    fun <T : BaseObject> save(`object`: T)

    fun <T : BaseMainObject> delete(obj: T)

    fun getLiveUser(id: String): User?
}
