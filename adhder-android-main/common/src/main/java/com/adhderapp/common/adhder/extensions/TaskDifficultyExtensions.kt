package com.adhderapp.common.adhder.extensions

import com.adhderapp.common.adhder.R
import com.adhderapp.shared.adhder.models.tasks.TaskDifficulty

val TaskDifficulty.nameRes: Int
    get() =
        when (this) {
            TaskDifficulty.TRIVIAL -> R.string.trivial
            TaskDifficulty.EASY -> R.string.easy
            TaskDifficulty.MEDIUM -> R.string.medium
            TaskDifficulty.HARD -> R.string.hard
        }

val TaskDifficulty.nameSentenceRes: Int
    get() =
        when (this) {
            TaskDifficulty.TRIVIAL -> R.string.trivial_sentence
            TaskDifficulty.EASY -> R.string.easy_sentence
            TaskDifficulty.MEDIUM -> R.string.medium_sentence
            TaskDifficulty.HARD -> R.string.hard_sentence
        }
