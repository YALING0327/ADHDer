package com.adhderapp.android.adhder.models.responses

import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.models.user.User

class SkillResponse {
    var user: User? = null
    var task: Task? = null
    var expDiff = 0.0
    var hpDiff = 0.0
    var goldDiff = 0.0
    var damage = 0.0f
}
