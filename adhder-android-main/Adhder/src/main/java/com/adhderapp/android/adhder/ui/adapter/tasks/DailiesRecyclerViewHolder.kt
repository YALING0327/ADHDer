package com.adhderapp.android.adhder.ui.adapter.tasks

import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.adhderapp.android.adhder.ui.viewHolders.tasks.DailyViewHolder
import com.adhderapp.android.adhder.ui.viewmodels.TasksViewModel

class DailiesRecyclerViewHolder(layoutResource: Int, viewModel: TasksViewModel) : RealmBaseTasksRecyclerViewAdapter(layoutResource, viewModel) {
    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): RecyclerView.ViewHolder {
        return if (viewType == 0) {
            DailyViewHolder(
                getContentView(parent),
                { task, direction -> taskScoreEvents?.invoke(task, direction) },
                { task, item -> checklistItemScoreEvents?.invoke(task, item) },
                {
                        task, view ->
                    taskOpenEvents?.invoke(task, view)
                },
                {
                        task ->
                    brokenTaskEvents?.invoke(task)
                },
                viewModel
            )
        } else {
            super.onCreateViewHolder(parent, viewType)
        }
    }
}
