package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.TutorialStep
import kotlinx.coroutines.flow.Flow

interface TutorialLocalRepository : BaseLocalRepository {
    fun getTutorialStep(key: String): Flow<TutorialStep>

    fun getTutorialSteps(keys: List<String>): Flow<List<TutorialStep>>
}
