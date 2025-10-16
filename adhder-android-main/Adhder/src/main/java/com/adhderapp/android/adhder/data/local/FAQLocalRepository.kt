package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.FAQArticle
import kotlinx.coroutines.flow.Flow

interface FAQLocalRepository : ContentLocalRepository {
    fun getArticle(position: Int): Flow<FAQArticle>

    val articles: Flow<List<FAQArticle>>
}
