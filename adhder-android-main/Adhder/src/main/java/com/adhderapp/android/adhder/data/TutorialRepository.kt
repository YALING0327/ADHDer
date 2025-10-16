package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.TutorialStep
import kotlinx.coroutines.flow.Flow

interface TutorialRepository : BaseRepository {
    fun getTutorialStep(key: String): Flow<TutorialStep>

    fun getTutorialSteps(keys: List<String>): Flow<out List<TutorialStep>>
}
