package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.social.Challenge
import com.adhderapp.android.adhder.models.social.ChallengeMembership
import com.adhderapp.android.adhder.models.tasks.Task
import kotlinx.coroutines.flow.Flow

interface ChallengeLocalRepository : BaseLocalRepository {
    val challenges: Flow<List<Challenge>>

    fun getChallenge(id: String): Flow<Challenge>

    fun getTasks(challengeID: String): Flow<List<Task>>

    fun getUserChallenges(userId: String): Flow<List<Challenge>>

    fun setParticipating(
        userID: String,
        challengeID: String,
        isParticipating: Boolean
    )

    fun saveChallenges(
        challenges: List<Challenge>,
        clearChallenges: Boolean,
        memberOnly: Boolean,
        userID: String
    )

    fun getChallengeMembership(
        userId: String,
        id: String
    ): Flow<ChallengeMembership>

    fun getChallengeMemberships(userId: String): Flow<List<ChallengeMembership>>

    fun isChallengeMember(
        userID: String,
        challengeID: String
    ): Flow<Boolean>
}
