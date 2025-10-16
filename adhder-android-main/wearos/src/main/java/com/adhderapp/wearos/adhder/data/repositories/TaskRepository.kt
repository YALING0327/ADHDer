package com.adhderapp.wearos.adhder.data.repositories

import com.adhderapp.shared.adhder.models.responses.TaskDirection
import com.adhderapp.shared.adhder.models.responses.TaskScoringResult
import com.adhderapp.shared.adhder.models.tasks.TaskType
import com.adhderapp.shared.adhder.models.tasks.TasksOrder
import com.adhderapp.wearos.adhder.data.ApiClient
import com.adhderapp.wearos.adhder.models.tasks.Task
import com.adhderapp.wearos.adhder.models.tasks.TaskList
import com.adhderapp.wearos.adhder.models.user.User
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow
import javax.inject.Inject

class TaskRepository
@Inject
constructor(
    private val apiClient: ApiClient,
    private val localRepository: TaskLocalRepository,
    private val userLocalRepository: UserLocalRepository
) {
    suspend fun retrieveTasks(
        order: TasksOrder?,
        ensureFresh: Boolean = false
    ): TaskList? {
        val response = apiClient.getTasks()
        var tasks = response.responseData
        tasks?.let { localRepository.saveTasks(it, order) }
        if (ensureFresh && !response.isResponseFresh) {
            tasks = apiClient.getTasks(true).responseData
            tasks?.let { localRepository.saveTasks(tasks, order) }
        }
        return tasks
    }

    fun getTasks(taskType: TaskType) = localRepository.getTasks(taskType)

    suspend fun scoreTask(
        user: User?,
        task: Task,
        direction: TaskDirection
    ): TaskScoringResult? {
        val id = task.id ?: return null
        val result = apiClient.scoreTask(id, direction.text).responseData
        if (result != null) {
            task.completed = direction == TaskDirection.UP
            task.value = (task.value ?: 0.0) + result.delta
            if (task.type == TaskType.HABIT) {
                if (direction == TaskDirection.UP) {
                    task.counterUp = task.counterUp?.plus(1) ?: 1
                } else {
                    task.counterDown = task.counterDown?.plus(1) ?: 1
                }
            } else if (task.type == TaskType.DAILY) {
                if (direction == TaskDirection.UP) {
                    task.streak = task.streak?.plus(1) ?: 1
                } else {
                    task.streak = task.streak?.minus(1) ?: 0
                }
            }
            localRepository.updateTask(task)
        }
        val scoringResult = result?.let { TaskScoringResult(it, user?.stats) }
        if (user != null) {
            user.stats?.hp = result?.hp
            user.stats?.exp = result?.exp
            user.stats?.mp = result?.mp
            user.stats?.gp = result?.gp
            user.stats?.lvl = result?.lvl
            userLocalRepository.saveUser(user)
        }
        return scoringResult
    }

    fun getTask(taskID: String?): Flow<Task?> {
        if (taskID == null) return emptyFlow()
        return localRepository.getTask(taskID)
    }

    suspend fun createTask(task: Task) {
        val newTask = apiClient.createTask(task).responseData
        if (newTask != null) {
            localRepository.updateTask(newTask)
        }
    }

    fun getTaskCounts() = localRepository.getTaskCounts()

    fun getActiveTaskCounts() = localRepository.getActiveTaskCounts()

    fun clearData() = localRepository.clearData()
}
