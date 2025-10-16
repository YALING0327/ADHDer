package com.adhderapp.wearos.adhder.ui.viewHolders.tasks

import android.view.View
import com.adhderapp.android.adhder.databinding.RowRewardBinding
import com.adhderapp.wearos.adhder.ui.views.TaskTextView

class RewardViewHolder(itemView: View) : TaskViewHolder(itemView) {
    private val binding = RowRewardBinding.bind(itemView)
    override val titleView: TaskTextView
        get() = binding.title
}
