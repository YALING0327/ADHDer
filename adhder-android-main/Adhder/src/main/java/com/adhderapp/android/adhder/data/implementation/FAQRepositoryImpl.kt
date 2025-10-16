package com.adhderapp.android.adhder.data.implementation

import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.FAQRepository
import com.adhderapp.android.adhder.data.local.FAQLocalRepository
import com.adhderapp.android.adhder.models.FAQArticle
import com.adhderapp.android.adhder.modules.AuthenticationHandler
import kotlinx.coroutines.flow.Flow

class FAQRepositoryImpl(
    localRepository: FAQLocalRepository,
    apiClient: ApiClient,
    authenticationHandler: AuthenticationHandler
) : BaseRepositoryImpl<FAQLocalRepository>(localRepository, apiClient, authenticationHandler),
    FAQRepository {
    override fun getArticle(position: Int): Flow<FAQArticle> {
        return localRepository.getArticle(position)
    }

    override fun getArticles(): Flow<List<FAQArticle>> {
        return localRepository.articles
    }
}
