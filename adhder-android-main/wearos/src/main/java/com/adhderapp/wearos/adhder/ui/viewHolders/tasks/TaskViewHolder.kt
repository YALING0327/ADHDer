package com.adhderapp.wearos.adhder.ui.viewHolders.tasks

import android.view.View
import com.adhderapp.wearos.adhder.models.tasks.Task
import com.adhderapp.wearos.adhder.ui.viewHolders.BindableViewHolder
import com.adhderapp.wearos.adhder.ui.views.TaskTextView

abstract class TaskViewHolder(itemView: View) : BindableViewHolder<Task>(itemView) {
    var onTaskScore: (() -> Unit)? = null
    abstract val titleView: TaskTextView

    override fun bind(data: Task) {
        titleView.text = data.text
    }
}
