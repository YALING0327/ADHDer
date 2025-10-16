package com.adhderapp.android.adhder.ui.views.promo

import androidx.recyclerview.widget.RecyclerView
import com.adhderapp.android.adhder.models.promotions.AdhderPromotion

class PromoMenuViewHolder(val promoView: PromoMenuView) : RecyclerView.ViewHolder(promoView) {
    fun bind(promo: AdhderPromotion) {
        promo.configurePromoMenuView(promoView)
    }
}
