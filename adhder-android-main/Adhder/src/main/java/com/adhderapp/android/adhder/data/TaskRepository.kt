package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.BaseMainObject
import com.adhderapp.android.adhder.models.responses.BulkTaskScoringData
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.models.tasks.TaskList
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.shared.adhder.models.responses.TaskScoringResult
import com.adhderapp.shared.adhder.models.tasks.TaskType
import com.adhderapp.shared.adhder.models.tasks.TasksOrder
import kotlinx.coroutines.flow.Flow
import java.util.Date

interface TaskRepository : BaseRepository {
    fun getTasks(
        taskType: TaskType,
        userID: String? = null,
        includedGroupIDs: Array<String>
    ): Flow<List<Task>>

    fun saveTasks(
        userId: String,
        order: TasksOrder,
        tasks: TaskList
    )

    suspend fun retrieveTasks(
        userId: String,
        tasksOrder: TasksOrder
    ): TaskList?

    suspend fun retrieveTasks(
        userId: String,
        tasksOrder: TasksOrder,
        dueDate: Date
    ): TaskList?

    suspend fun taskChecked(
        user: User?,
        task: Task,
        up: Boolean,
        force: Boolean,
        notifyFunc: ((TaskScoringResult) -> Unit)?
    ): TaskScoringResult?

    suspend fun taskChecked(
        user: User?,
        taskId: String,
        up: Boolean,
        force: Boolean,
        notifyFunc: ((TaskScoringResult) -> Unit)?
    ): TaskScoringResult?

    suspend fun scoreChecklistItem(
        taskId: String,
        itemId: String
    ): Task?

    fun getTask(taskId: String): Flow<Task>

    fun getTaskCopy(taskId: String): Flow<Task>

    suspend fun createTask(
        task: Task,
        force: Boolean = false
    ): Task?

    suspend fun updateTask(
        task: Task,
        force: Boolean = false
    ): Task?

    suspend fun deleteTask(taskId: String): Void?

    fun saveTask(task: Task)

    suspend fun createTasks(newTasks: List<Task>): List<Task>?

    fun markTaskCompleted(
        taskId: String,
        isCompleted: Boolean
    )

    fun <T : BaseMainObject> modify(
        obj: T,
        transaction: (T) -> Unit
    )

    fun swapTaskPosition(
        firstPosition: Int,
        secondPosition: Int
    )

    suspend fun updateTaskPosition(
        taskType: TaskType,
        taskID: String,
        newPosition: Int
    ): List<String>?

    fun getUnmanagedTask(taskid: String): Flow<Task>

    fun updateTaskInBackground(
        task: Task,
        assignChanges: Map<String, MutableList<String>>
    )

    fun createTaskInBackground(
        task: Task,
        assignChanges: Map<String, MutableList<String>>
    )

    fun getTaskCopies(): Flow<List<Task>>

    fun getTaskCopies(tasks: List<Task>): List<Task>

    suspend fun retrieveDailiesFromDate(date: Date): TaskList?

    suspend fun retrieveCompletedTodos(userId: String? = null): TaskList?

    suspend fun syncErroredTasks(): List<Task>?

    suspend fun unlinkAllTasks(
        challengeID: String?,
        keepOption: String
    ): Void?

    fun getTasksForChallenge(challengeID: String?): Flow<List<Task>>

    suspend fun bulkScoreTasks(data: List<Map<String, String>>): BulkTaskScoringData?

    suspend fun markTaskNeedsWork(
        task: Task,
        userID: String
    )
}
