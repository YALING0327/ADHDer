package com.adhderapp.common.adhder.extensions

import com.adhderapp.common.adhder.R
import com.adhderapp.shared.adhder.models.tasks.HabitResetOption

val HabitResetOption.nameRes: Int
    get() =
        when (this) {
            HabitResetOption.DAILY -> R.string.daily
            HabitResetOption.WEEKLY -> R.string.weekly
            HabitResetOption.MONTHLY -> R.string.monthly
        }
