package com.adhderapp.wearos.adhder.ui.viewHolders

import android.view.View
import com.adhderapp.android.adhder.databinding.RowSpacerBinding

class SpacerViewHolder(itemView: View) : BindableViewHolder<Int>(itemView) {
    private val binding = RowSpacerBinding.bind(itemView)

    override fun bind(data: Int) {
        binding.root.layoutParams.height = data
    }
}
