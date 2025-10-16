package com.adhderapp.android.adhder.widget

import android.content.Context
import android.content.Intent
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.shared.adhder.models.tasks.TaskType

class DailiesListFactory(
    context: Context,
    intent: Intent,
    taskRepository: TaskRepository,
    userRepository: UserRepository
) : TaskListFactory(
    context,
    intent,
    TaskType.DAILY,
    R.layout.widget_dailies_list_row,
    R.id.dailies_text,
    taskRepository,
    userRepository
)
