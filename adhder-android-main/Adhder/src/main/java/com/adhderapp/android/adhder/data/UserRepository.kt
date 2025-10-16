package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.Achievement
import com.adhderapp.android.adhder.models.QuestAchievement
import com.adhderapp.android.adhder.models.Skill
import com.adhderapp.android.adhder.models.TeamPlan
import com.adhderapp.android.adhder.models.inventory.Customization
import com.adhderapp.android.adhder.models.inventory.Equipment
import com.adhderapp.android.adhder.models.responses.SkillResponse
import com.adhderapp.android.adhder.models.responses.UnlockResponse
import com.adhderapp.android.adhder.models.social.Group
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.models.user.Stats
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.models.user.UserQuestStatus
import com.adhderapp.common.adhder.models.Notification
import com.adhderapp.common.adhder.models.auth.UserAuthResponse
import com.adhderapp.shared.adhder.models.responses.VerifyUsernameResponse
import com.adhderapp.shared.adhder.models.tasks.Attribute
import kotlinx.coroutines.flow.Flow

interface UserRepository : BaseRepository {
    fun getUser(): Flow<User?>

    fun getUser(userID: String): Flow<User?>

    suspend fun updateUser(updateData: Map<String, Any?>): User?

    suspend fun updateUser(
        key: String,
        value: Any?
    ): User?

    suspend fun retrieveUser(
        withTasks: Boolean = false,
        forced: Boolean = false,
        overrideExisting: Boolean = false
    ): User?

    suspend fun revive(): Equipment?

    suspend fun resetTutorial(): User?

    suspend fun sleep(user: User): User?

    fun getSkills(user: User): Flow<List<Skill>>

    fun getSpecialItems(user: User): Flow<List<Skill>>

    suspend fun useSkill(
        key: String,
        target: String?,
        taskId: String
    ): SkillResponse?

    suspend fun useSkill(
        key: String,
        target: String?
    ): SkillResponse?

    suspend fun disableClasses(): User?

    suspend fun changeClass(selectedClass: String? = null): User?

    suspend fun unlockPath(
        path: String,
        price: Int
    ): UnlockResponse?

    suspend fun unlockPath(customization: Customization): UnlockResponse?

    suspend fun runCron(tasks: MutableList<Task>)

    suspend fun runCron()

    suspend fun getNews(): List<Any>?

    suspend fun getNewsNotification(): Notification?

    suspend fun readNotification(id: String): List<Any>?

    suspend fun readNotifications(notificationIds: Map<String, List<String>>): List<Any>?

    suspend fun seeNotifications(notificationIds: Map<String, List<String>>): List<Any>?

    suspend fun changeCustomDayStart(dayStartTime: Int): User?

    suspend fun updateLanguage(languageCode: String): User?

    suspend fun resetAccount(password: String): Boolean?

    suspend fun deleteAccount(password: String): Void?

    suspend fun sendPasswordResetEmail(email: String): Void?

    suspend fun updateLoginName(
        newLoginName: String,
        password: String? = null
    ): User?

    suspend fun updateEmail(
        newEmail: String,
        password: String
    ): Void?

    suspend fun updatePassword(
        oldPassword: String,
        newPassword: String,
        newPasswordConfirmation: String
    ): UserAuthResponse?

    suspend fun verifyUsername(username: String): VerifyUsernameResponse?

    suspend fun allocatePoint(stat: Attribute): Stats?

    suspend fun bulkAllocatePoints(
        strength: Int,
        intelligence: Int,
        constitution: Int,
        perception: Int
    ): Stats?

    suspend fun useCustomization(
        type: String,
        category: String?,
        identifier: String
    ): User?

    suspend fun retrieveAchievements(): List<Achievement>?

    fun getAchievements(): Flow<List<Achievement>>

    fun getQuestAchievements(): Flow<List<QuestAchievement>>

    fun getUserQuestStatus(): Flow<UserQuestStatus>

    suspend fun reroll(): User?

    suspend fun retrieveTeamPlans(): List<TeamPlan>?

    fun getTeamPlans(): Flow<List<TeamPlan>>

    suspend fun retrieveTeamPlan(teamID: String): Group?

    fun getTeamPlan(teamID: String): Flow<Group?>

    suspend fun syncUserStats(): User?
}
