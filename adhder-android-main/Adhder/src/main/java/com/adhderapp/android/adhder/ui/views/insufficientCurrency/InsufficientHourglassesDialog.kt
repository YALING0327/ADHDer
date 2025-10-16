package com.adhderapp.android.adhder.ui.views.insufficientCurrency

import android.content.Context
import android.os.Bundle
import androidx.core.os.bundleOf
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.extensions.addCloseButton
import com.adhderapp.android.adhder.ui.views.AdhderIconsHelper
import com.adhderapp.common.adhder.helpers.MainNavigationController

class InsufficientHourglassesDialog(context: Context) : InsufficientCurrencyDialog(context) {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        imageView.setImageBitmap(AdhderIconsHelper.imageOfHourglassShop())
        textView.setText(R.string.insufficientHourglasses)

        addButton(
            R.string.get_hourglasses,
            true
        ) { _, _ ->
            MainNavigationController.navigate(
                R.id.gemPurchaseActivity,
                bundleOf(Pair("openSubscription", true))
            )
        }
        addCloseButton()
    }
}
