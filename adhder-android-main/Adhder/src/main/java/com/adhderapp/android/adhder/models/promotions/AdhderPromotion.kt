package com.adhderapp.android.adhder.models.promotions

import android.content.Context
import android.graphics.drawable.Drawable
import com.adhderapp.android.adhder.BuildConfig
import com.adhderapp.android.adhder.databinding.FragmentGemPurchaseBinding
import com.adhderapp.android.adhder.databinding.FragmentSubscriptionBinding
import com.adhderapp.android.adhder.databinding.PurchaseGemViewBinding
import com.adhderapp.android.adhder.ui.fragments.PromoInfoFragment
import com.adhderapp.android.adhder.ui.views.promo.PromoMenuView
import java.util.Date

enum class PromoType {
    GEMS_AMOUNT,
    GEMS_PRICE,
    SUBSCRIPTION,
    SURVEY
}

abstract class AdhderPromotion {
    val isActive: Boolean
        get() {
            val now = Date()
            if (BuildConfig.TESTING_LEVEL == "staff") {
                return startDate.before(now)
            }
            return startDate.before(now) && endDate.after(now)
        }
    abstract val identifier: String
    abstract val promoType: PromoType

    abstract val startDate: Date
    abstract val endDate: Date

    abstract fun pillBackgroundDrawable(context: Context): Drawable

    abstract fun backgroundColor(context: Context): Int

    abstract fun promoBackgroundDrawable(context: Context): Drawable

    abstract fun buttonDrawable(context: Context): Drawable

    abstract fun configurePromoMenuView(view: PromoMenuView)

    abstract fun menuOnNavigation(context: Context)

    abstract fun configurePurchaseBanner(binding: FragmentGemPurchaseBinding)

    abstract fun configurePurchaseBanner(binding: FragmentSubscriptionBinding)

    abstract fun configureGemView(
        binding: PurchaseGemViewBinding,
        regularAmount: Int
    )

    abstract fun configureInfoFragment(fragment: PromoInfoFragment)
}

fun getAdhderPromotionFromKey(
    key: String,
    startDate: Date?,
    endDate: Date?
): AdhderPromotion? {
    return when (key) {
        "fall_extra_gems", "fall2020", "testFall2020" ->
            FallExtraGemsAdhderPromotion(
                startDate,
                endDate
            )

        "spooky_extra_gems", "fall2020SecondPromo", "spooky2020" ->
            SpookyExtraGemsAdhderPromotion(
                startDate,
                endDate
            )

        "g1g1" -> GiftOneGetOneAdhderPromotion(startDate, endDate)
        "survey2021" -> Survey2021Promotion()
        else -> null
    }
}

interface AdhderWebPromotion {
    var url: String?
}
