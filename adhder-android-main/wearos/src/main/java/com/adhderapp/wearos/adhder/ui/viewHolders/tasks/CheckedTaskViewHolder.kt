package com.adhderapp.wearos.adhder.ui.viewHolders.tasks

import android.content.res.ColorStateList
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.core.content.ContextCompat
import com.adhderapp.android.adhder.R
import com.adhderapp.wearos.adhder.models.tasks.Task

abstract class CheckedTaskViewHolder(itemView: View) : TaskViewHolder(itemView) {
    abstract val checkbox: ImageView
    abstract val checkboxWrapper: ViewGroup

    override fun bind(data: Task) {
        checkboxWrapper.setOnClickListener {
            onTaskScore?.invoke()
        }
        super.bind(data)
        if (data.completed) {
            checkbox.setImageResource(R.drawable.checkmark)
            checkboxWrapper.backgroundTintList =
                ColorStateList.valueOf(ContextCompat.getColor(itemView.context, R.color.transparent))
            checkbox.backgroundTintList =
                ColorStateList.valueOf(
                    ContextCompat.getColor(
                        itemView.context,
                        R.color.gray_300
                    )
                )
        } else {
            checkbox.setImageDrawable(null)

            checkboxWrapper.backgroundTintList =
                ColorStateList.valueOf(ContextCompat.getColor(itemView.context, data.lightTaskColor))
            checkbox.backgroundTintList =
                ColorStateList.valueOf(
                    ContextCompat.getColor(
                        itemView.context,
                        data.extraLightTaskColor
                    )
                )
        }
    }
}
