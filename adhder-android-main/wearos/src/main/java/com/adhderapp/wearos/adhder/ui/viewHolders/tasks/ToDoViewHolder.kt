package com.adhderapp.wearos.adhder.ui.viewHolders.tasks

import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.adhderapp.android.adhder.databinding.RowTodoBinding
import com.adhderapp.wearos.adhder.ui.views.TaskTextView

class ToDoViewHolder(itemView: View) : CheckedTaskViewHolder(itemView) {
    private val binding = RowTodoBinding.bind(itemView)
    override val titleView: TaskTextView
        get() = binding.title
    override val checkbox: ImageView
        get() = binding.checkbox
    override val checkboxWrapper: ViewGroup
        get() = binding.checkboxWrapper
}
