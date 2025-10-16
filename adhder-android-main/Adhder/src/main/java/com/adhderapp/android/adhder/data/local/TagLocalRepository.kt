package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.Tag
import kotlinx.coroutines.flow.Flow

interface TagLocalRepository : BaseLocalRepository {
    fun getTags(userId: String): Flow<List<Tag>>

    fun deleteTag(tagID: String)
}
