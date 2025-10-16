package com.adhderapp.wearos.adhder.ui.viewHolders

import android.view.View
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.databinding.RowHeaderBinding

class HeaderViewHolder(itemView: View) : BindableViewHolder<String>(itemView) {
    private val binding = RowHeaderBinding.bind(itemView)

    override fun bind(data: String) {
        if (data == itemView.context.resources.getString(R.string.settings)) {
            binding.textView.setTextColor(ContextCompat.getColor(itemView.context, R.color.white))
        }
        binding.textView.text = data
        binding.textView.isVisible = data.isNotBlank()
    }

    fun setIsDisconnected(isDisconnected: Boolean) {
        binding.disconnected.root.isVisible = isDisconnected
    }
}
