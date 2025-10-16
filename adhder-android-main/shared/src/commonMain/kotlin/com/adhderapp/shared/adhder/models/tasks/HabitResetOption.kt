package com.adhderapp.shared.adhder.models.tasks

enum class HabitResetOption(val value: Frequency) {
    DAILY(Frequency.DAILY),
    WEEKLY(Frequency.WEEKLY),
    MONTHLY(Frequency.MONTHLY)
    ;

    companion object {
        fun from(type: Frequency?): HabitResetOption? = values().find { it.value == type }
    }
}
