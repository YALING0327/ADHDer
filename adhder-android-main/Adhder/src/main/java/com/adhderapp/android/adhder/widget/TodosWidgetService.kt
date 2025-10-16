package com.adhderapp.android.adhder.widget

import android.content.Intent
import android.widget.RemoteViewsService
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.UserRepository
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class TodosWidgetService : RemoteViewsService() {
    @Inject
    lateinit var taskRepository: TaskRepository

    @Inject
    lateinit var userRepository: UserRepository

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TodoListFactory(this.applicationContext, intent, taskRepository, userRepository)
    }
}
