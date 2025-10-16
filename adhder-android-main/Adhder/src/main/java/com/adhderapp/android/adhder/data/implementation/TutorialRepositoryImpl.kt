package com.adhderapp.android.adhder.data.implementation

import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.TutorialRepository
import com.adhderapp.android.adhder.data.local.TutorialLocalRepository
import com.adhderapp.android.adhder.models.TutorialStep
import com.adhderapp.android.adhder.modules.AuthenticationHandler
import kotlinx.coroutines.flow.Flow

class TutorialRepositoryImpl(
    localRepository: TutorialLocalRepository,
    apiClient: ApiClient,
    authenticationHandler: AuthenticationHandler
) : BaseRepositoryImpl<TutorialLocalRepository>(localRepository, apiClient, authenticationHandler),
    TutorialRepository {
    override fun getTutorialStep(key: String): Flow<TutorialStep> =
        localRepository.getTutorialStep(key)

    override fun getTutorialSteps(keys: List<String>): Flow<List<TutorialStep>> =
        localRepository.getTutorialSteps(keys)
}
