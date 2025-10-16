package com.adhderapp.wearos.adhder.models

class WearableHabitResponse<T> {
    var data: T? = null
    var success: Boolean = false
    var message: String? = null
    val isFresh: Boolean = true
}
