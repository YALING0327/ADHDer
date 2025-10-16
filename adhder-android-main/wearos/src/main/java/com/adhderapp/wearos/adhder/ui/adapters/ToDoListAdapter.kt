package com.adhderapp.wearos.adhder.ui.adapters

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.adhderapp.android.adhder.databinding.RowTodoBinding
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.wearos.adhder.ui.viewHolders.tasks.ToDoViewHolder

class ToDoListAdapter : TaskListAdapter() {
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): RecyclerView.ViewHolder {
        return if (viewType == 1) {
            return ToDoViewHolder(RowTodoBinding.inflate(parent.context.layoutInflater, parent, false).root)
        } else {
            super.onCreateViewHolder(parent, viewType)
        }
    }
}
