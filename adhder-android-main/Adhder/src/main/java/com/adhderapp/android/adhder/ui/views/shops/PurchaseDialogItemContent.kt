package com.adhderapp.android.adhder.ui.views.shops

import android.content.Context
import android.widget.TextView
import com.adhderapp.android.adhder.databinding.DialogPurchaseContentItemBinding
import com.adhderapp.android.adhder.models.shops.ShopItem
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.views.PixelArtView

class PurchaseDialogItemContent(context: Context) : PurchaseDialogContent(context) {
    private val binding = DialogPurchaseContentItemBinding.inflate(context.layoutInflater, this)
    override val imageView: PixelArtView
        get() = binding.imageView
    override val titleTextView: TextView
        get() = binding.titleTextView

    override fun setItem(item: ShopItem) {
        super.setItem(item)
        binding.notesTextView.text = item.notes
        binding.stepperView.iconDrawable = null
    }
}
