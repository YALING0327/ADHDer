package com.adhderapp.android.adhder.ui.fragments.inventory.shops

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.adhderapp.android.adhder.models.shops.Shop
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MarketFragment : ShopFragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        shopIdentifier = Shop.MARKET
        return super.onCreateView(inflater, container, savedInstanceState)
    }
}
