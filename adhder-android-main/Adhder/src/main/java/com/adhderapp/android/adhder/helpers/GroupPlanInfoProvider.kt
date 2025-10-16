package com.adhderapp.android.adhder.helpers

import android.content.res.Resources
import com.adhderapp.android.adhder.models.tasks.Task

interface GroupPlanInfoProvider {
    fun assignedTextForTask(
        resources: Resources,
        assignedUsers: List<String>
    ): String

    fun canScoreTask(task: Task): Boolean

    suspend fun canEditTask(task: Task): Boolean

    suspend fun canAddTasks(): Boolean
}
