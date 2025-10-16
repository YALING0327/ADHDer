package com.adhderapp.android.adhder.widget

import android.content.Context
import android.content.Intent
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.shared.adhder.models.tasks.TaskType

class TodoListFactory(
    context: Context,
    intent: Intent,
    taskRepository: TaskRepository,
    userRepository: UserRepository
) : TaskListFactory(
    context,
    intent,
    TaskType.TODO,
    R.layout.widget_todo_list_row,
    R.id.todo_text,
    taskRepository,
    userRepository
)
