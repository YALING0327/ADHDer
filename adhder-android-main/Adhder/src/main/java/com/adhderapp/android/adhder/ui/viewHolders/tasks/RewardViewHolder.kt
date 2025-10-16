package com.adhderapp.android.adhder.ui.viewHolders.tasks

import android.view.View
import androidx.core.content.ContextCompat
import androidx.core.graphics.ColorUtils
import androidx.core.graphics.drawable.toDrawable
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.databinding.RewardItemCardBinding
import com.adhderapp.android.adhder.helpers.GroupPlanInfoProvider
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.ui.views.AdhderIconsHelper
import com.adhderapp.common.adhder.extensions.dpToPx
import com.adhderapp.common.adhder.helpers.NumberAbbreviator
import com.adhderapp.shared.adhder.models.responses.TaskDirection

class RewardViewHolder(
    itemView: View,
    scoreTaskFunc: ((Task, TaskDirection) -> Unit),
    openTaskFunc: ((Task, View) -> Unit),
    brokenTaskFunc: ((Task) -> Unit),
    assignedTextProvider: GroupPlanInfoProvider?
) : BaseTaskViewHolder(
    itemView,
    scoreTaskFunc,
    openTaskFunc,
    brokenTaskFunc,
    assignedTextProvider
) {
    private val binding = RewardItemCardBinding.bind(itemView)

    init {
        binding.buyButton.setOnClickListener {
            buyReward()
        }
        binding.goldIcon.setImageBitmap(AdhderIconsHelper.imageOfGold())
    }

    private fun buyReward() {
        task?.let { scoreTaskFunc(it, TaskDirection.DOWN) }
    }

    override fun setDisabled(
        openTaskDisabled: Boolean,
        taskActionsDisabled: Boolean
    ) {
        super.setDisabled(openTaskDisabled, taskActionsDisabled)
        binding.buyButton.isEnabled = !taskActionsDisabled
    }

    fun bind(
        reward: Task,
        position: Int,
        canBuy: Boolean,
        displayMode: String,
        ownerID: String?
    ) {
        this.task = reward
        streakTextView.visibility = View.GONE
        super.bind(reward, position, displayMode, ownerID)
        binding.priceLabel.text =
            NumberAbbreviator.abbreviate(itemView.context, this.task?.value ?: 0.0)

        if (isLocked) {
            binding.priceLabel.setCompoundDrawablesWithIntrinsicBounds(
                AdhderIconsHelper.imageOfLocked(
                    ContextCompat.getColor(context, R.color.gray_1_30),
                    10,
                    12
                ).toDrawable(context.resources),
                null,
                null,
                null
            )
            binding.priceLabel.compoundDrawablePadding = 2.dpToPx(context)
        } else {
            binding.priceLabel.setCompoundDrawables(null, null, null, null)
        }
        if (canBuy && !isLocked) {
            binding.goldIcon.alpha = 1.0f
            binding.priceLabel.setTextColor(
                ContextCompat.getColor(
                    context,
                    R.color.reward_buy_button_text
                )
            )
            binding.buyButton.setBackgroundColor(
                ContextCompat.getColor(
                    context,
                    R.color.reward_buy_button_bg
                )
            )
        } else {
            binding.goldIcon.alpha = 0.6f
            binding.priceLabel.setTextColor(ContextCompat.getColor(context, R.color.text_quad))
            binding.buyButton.setBackgroundColor(
                ColorUtils.setAlphaComponent(
                    ContextCompat.getColor(
                        context,
                        R.color.offset_background
                    ),
                    127
                )
            )
        }
    }
}
