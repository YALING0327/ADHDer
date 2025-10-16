package com.adhderapp.android.adhder.ui.views.promo

import android.content.Context
import android.util.AttributeSet
import android.widget.Button
import android.widget.RelativeLayout
import androidx.core.os.bundleOf
import com.adhderapp.android.adhder.R
import com.adhderapp.common.adhder.extensions.getThemeColor
import com.adhderapp.common.adhder.extensions.inflate
import com.adhderapp.common.adhder.helpers.MainNavigationController

class SubscriptionBuyGemsPromoView
@JvmOverloads
constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : RelativeLayout(context, attrs, defStyleAttr) {
    init {
        inflate(R.layout.promo_subscription_buy_gems, true)
        setBackgroundColor(context.getThemeColor(R.attr.colorWindowBackground))
        clipToPadding = false
        clipChildren = false
        clipToOutline = false
        findViewById<Button>(R.id.button).setOnClickListener {
            MainNavigationController.navigate(
                R.id.gemPurchaseActivity,
                bundleOf(Pair("openSubscription", true))
            )
        }
    }
}
