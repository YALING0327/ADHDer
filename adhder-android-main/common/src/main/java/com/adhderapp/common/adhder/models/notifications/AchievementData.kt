package com.adhderapp.common.adhder.models.notifications

open class AchievementData : NotificationData {
    val isLastOnboardingAchievement: Boolean = false
    var achievement: String? = null
    var message: String? = null
    var modalText: String? = null
}
