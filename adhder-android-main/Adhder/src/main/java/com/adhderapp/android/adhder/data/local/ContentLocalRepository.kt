package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.ContentResult
import com.adhderapp.android.adhder.models.WorldState
import kotlinx.coroutines.flow.Flow

interface ContentLocalRepository : BaseLocalRepository {
    fun saveContent(contentResult: ContentResult)

    fun saveWorldState(worldState: WorldState)

    fun getWorldState(): Flow<WorldState>
}
