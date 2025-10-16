package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.Achievement
import com.adhderapp.android.adhder.models.QuestAchievement
import com.adhderapp.android.adhder.models.Skill
import com.adhderapp.android.adhder.models.TeamPlan
import com.adhderapp.android.adhder.models.TutorialStep
import com.adhderapp.android.adhder.models.social.ChatMessage
import com.adhderapp.android.adhder.models.social.Group
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.models.user.UserQuestStatus
import io.realm.RealmResults
import kotlinx.coroutines.flow.Flow

interface UserLocalRepository : BaseLocalRepository {
    suspend fun getTutorialSteps(): Flow<RealmResults<TutorialStep>>

    fun getUser(userID: String): Flow<User?>

    fun saveUser(
        user: User,
        overrideExisting: Boolean = true
    )

    fun saveMessages(messages: List<ChatMessage>)

    fun getSkills(user: User): Flow<List<Skill>>

    fun getSpecialItems(user: User): Flow<List<Skill>>

    fun getAchievements(): Flow<List<Achievement>>

    fun getQuestAchievements(userID: String): Flow<List<QuestAchievement>>

    fun getUserQuestStatus(userID: String): Flow<UserQuestStatus>

    fun getTeamPlans(userID: String): Flow<List<TeamPlan>>

    fun getTeamPlan(teamID: String): Flow<Group?>
}
