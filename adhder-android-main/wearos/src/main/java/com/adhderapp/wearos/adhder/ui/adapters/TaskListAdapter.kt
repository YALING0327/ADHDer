package com.adhderapp.wearos.adhder.ui.adapters

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.adhderapp.android.adhder.databinding.RowTaskHeaderBinding
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.wearos.adhder.models.tasks.Task
import com.adhderapp.wearos.adhder.ui.viewHolders.HeaderTaskViewHolder
import com.adhderapp.wearos.adhder.ui.viewHolders.tasks.TaskViewHolder

open class TaskListAdapter : BaseAdapter<Any>() {
    var onTaskScore: ((Task) -> Unit)? = null
    var onTaskTapped: ((Task) -> Unit)? = null

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): RecyclerView.ViewHolder {
        return if (viewType == TYPE_HEADER) {
            val inflater = parent.context.layoutInflater
            HeaderTaskViewHolder(RowTaskHeaderBinding.inflate(inflater, parent, false).root)
        } else {
            super.onCreateViewHolder(parent, viewType)
        }
    }

    override fun onBindViewHolder(
        holder: RecyclerView.ViewHolder,
        position: Int
    ) {
        if (holder is TaskViewHolder) {
            val item = getItemAt(position) as Task
            holder.bind(item)
            holder.onTaskScore = {
                onTaskScore?.invoke(item)
            }
            holder.itemView.setOnClickListener {
                onTaskTapped?.invoke(item)
            }
        } else if (holder is HeaderTaskViewHolder) {
            if (position == 0) {
                holder.bind(title, data.firstOrNull() is String, isDisconnected)
                holder.itemView.setOnClickListener {
                    onRefresh?.invoke()
                }
            } else {
                holder.bind(data[position - 1] as String, false, isDisconnected)
            }
        } else {
            super.onBindViewHolder(holder, position)
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (position == 0) {
            TYPE_HEADER
        } else {
            val item = data[position - 1]
            if (item is Task) 1 else TYPE_HEADER
        }
    }
}
