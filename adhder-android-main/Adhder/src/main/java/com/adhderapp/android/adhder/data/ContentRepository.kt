package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.ContentResult
import com.adhderapp.android.adhder.models.WorldState
import kotlinx.coroutines.flow.Flow

interface ContentRepository : BaseRepository {
    suspend fun retrieveContent(forced: Boolean = false): ContentResult?

    suspend fun retrieveWorldState(forced: Boolean = false): WorldState?

    fun getWorldState(): Flow<WorldState>
}
