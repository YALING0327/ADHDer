package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.FAQArticle
import kotlinx.coroutines.flow.Flow

interface FAQRepository : BaseRepository {
    fun getArticles(): Flow<List<FAQArticle>>

    fun getArticle(position: Int): Flow<FAQArticle>
}
