package com.adhderapp.android.adhder.interactors

import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.helpers.SoundManager
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.shared.adhder.models.responses.TaskScoringResult
import javax.inject.Inject

class BuyRewardUseCase
@Inject
constructor(
    private val taskRepository: TaskRepository,
    private val soundManager: SoundManager
) : UseCase<BuyRewardUseCase.RequestValues, TaskScoringResult?>() {
    override suspend fun run(requestValues: RequestValues): TaskScoringResult? {
        val response =
            taskRepository.taskChecked(
                requestValues.user,
                requestValues.task,
                false,
                false,
                requestValues.notifyFunc
            )
        soundManager.loadAndPlayAudio(SoundManager.SOUND_REWARD)
        return response
    }

    class RequestValues(
        internal val user: User?,
        val task: Task,
        val notifyFunc: (TaskScoringResult) -> Unit
    ) : UseCase.RequestValues
}
