package com.adhderapp.wearos.adhder.ui.viewHolders

import android.view.View
import androidx.recyclerview.widget.RecyclerView

abstract class BindableViewHolder<T>(itemView: View) : RecyclerView.ViewHolder(itemView) {
    abstract fun bind(data: T)
}
