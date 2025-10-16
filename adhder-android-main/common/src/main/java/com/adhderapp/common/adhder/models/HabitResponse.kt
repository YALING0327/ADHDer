package com.adhderapp.common.adhder.models

class HabitResponse<T> {
    var data: T? = null
    var notifications: List<Notification>? = null
    var success: Boolean? = null
    var message: String? = null
}
