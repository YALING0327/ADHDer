package com.adhderapp.android.adhder.ui.views.insufficientCurrency

import android.content.Context
import android.os.Bundle
import com.adhderapp.android.adhder.R

class InsufficientSubscriberGemsDialog(context: Context) : InsufficientCurrencyDialog(context) {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        imageView.setImageResource(R.drawable.subscriber_gem_cap)
        textView.text = context.getString(R.string.insufficientSubscriberGems)
        addButton(R.string.take_me_back, true)
    }
}
