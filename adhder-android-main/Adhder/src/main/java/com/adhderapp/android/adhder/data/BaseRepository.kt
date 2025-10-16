package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.BaseObject

interface BaseRepository {
    val isClosed: Boolean

    fun close()

    fun <T : BaseObject> getUnmanagedCopy(obj: T): T

    fun <T : BaseObject> getUnmanagedCopy(list: List<T>): List<T>
}
