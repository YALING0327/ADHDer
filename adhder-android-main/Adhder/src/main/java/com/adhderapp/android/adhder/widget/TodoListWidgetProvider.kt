package com.adhderapp.android.adhder.widget

import com.adhderapp.android.adhder.R

class TodoListWidgetProvider : TaskListWidgetProvider() {
    override val serviceClass: Class<*>
        get() = TodosWidgetService::class.java

    override val providerClass: Class<*>
        get() = TodoListWidgetProvider::class.java

    override val titleResId: Int
        get() = R.string.todos
}
