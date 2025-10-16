package com.adhderapp.android.adhder.ui.adapter.tasks

import android.view.View
import com.adhderapp.android.adhder.models.tasks.ChecklistItem
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.shared.adhder.models.responses.TaskDirection

interface TaskRecyclerViewAdapter {
    var user: User?
    var showAdventureGuide: Boolean
    var data: List<Task>

    var errorButtonEvents: ((String) -> Unit)?

    var taskDisplayMode: String

    fun filter()

    fun notifyItemMoved(
        adapterPosition: Int,
        adapterPosition1: Int
    )

    fun notifyDataSetChanged()

    fun getItemViewType(position: Int): Int

    fun updateUnfilteredData(data: List<Task>?)

    var taskScoreEvents: ((Task, TaskDirection) -> Unit)?
    var checklistItemScoreEvents: ((Task, ChecklistItem) -> Unit)?
    var taskOpenEvents: ((Task, View) -> Unit)?
    var brokenTaskEvents: ((Task) -> Unit)?
    var adventureGuideOpenEvents: ((Boolean) -> Unit)?
}
