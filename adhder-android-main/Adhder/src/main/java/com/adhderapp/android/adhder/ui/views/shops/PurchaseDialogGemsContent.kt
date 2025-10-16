package com.adhderapp.android.adhder.ui.views.shops

import android.content.Context
import android.widget.TextView
import com.adhderapp.android.adhder.databinding.DialogPurchaseGemsBinding
import com.adhderapp.android.adhder.extensions.asDrawable
import com.adhderapp.android.adhder.models.shops.ShopItem
import com.adhderapp.android.adhder.ui.views.AdhderIconsHelper
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.views.PixelArtView

internal class PurchaseDialogGemsContent(context: Context) : PurchaseDialogContent(context) {
    internal val binding = DialogPurchaseGemsBinding.inflate(context.layoutInflater, this)
    override val imageView: PixelArtView
        get() = binding.imageView
    override val titleTextView: TextView
        get() = binding.titleTextView

    init {
        binding.stepperView.iconDrawable =
            AdhderIconsHelper.imageOfGem().asDrawable(context.resources)
    }

    override fun setItem(item: ShopItem) {
        super.setItem(item)
        binding.notesTextView.text = item.notes
    }
}
