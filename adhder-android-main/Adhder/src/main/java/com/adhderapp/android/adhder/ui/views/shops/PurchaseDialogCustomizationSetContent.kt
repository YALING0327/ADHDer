package com.adhderapp.android.adhder.ui.views.shops

import android.content.Context
import android.widget.TextView
import com.google.android.flexbox.FlexboxLayout
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.databinding.DialogPurchaseCustomizationsetBinding
import com.adhderapp.android.adhder.models.shops.ShopItem
import com.adhderapp.common.adhder.extensions.dpToPx
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.extensions.loadImage
import com.adhderapp.common.adhder.views.PixelArtView

class PurchaseDialogCustomizationSetContent(context: Context) : PurchaseDialogContent(context) {
    val binding = DialogPurchaseCustomizationsetBinding.inflate(context.layoutInflater, this)
    override val imageView: PixelArtView
        get() = PixelArtView(context)
    override val titleTextView: TextView
        get() = binding.titleTextView

    override fun setItem(item: ShopItem) {
        titleTextView.text = item.text
        binding.imageViewWrapper.removeAllViews()
        item.setImageNames.forEach {
            val imageView = PixelArtView(context)
            imageView.setBackgroundResource(R.drawable.layout_rounded_bg_window)
            imageView.loadImage(it)
            imageView.layoutParams =
                FlexboxLayout.LayoutParams(76.dpToPx(context), 76.dpToPx(context))
            binding.imageViewWrapper.addView(imageView)
        }
        if (item.key == "facialHair") {
            binding.notesTextView.text = context.getString(R.string.facial_hair_notes)
        } else {
            binding.notesTextView.text = item.notes
        }
    }
}
