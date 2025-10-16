package com.adhderapp.android.adhder.ui.views.shops

import android.content.Context
import android.widget.TextView
import com.adhderapp.android.adhder.databinding.DialogPurchaseContentItemBinding
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.views.PixelArtView

class PurchaseDialogBaseContent(context: Context) : PurchaseDialogContent(context) {
    val binding = DialogPurchaseContentItemBinding.inflate(context.layoutInflater, this)
    override val imageView: PixelArtView
        get() = binding.imageView
    override val titleTextView: TextView
        get() = binding.titleTextView
}
