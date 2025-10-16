package com.adhderapp.android.adhder.ui.fragments.purchases

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.ViewGroup
import com.android.billingclient.api.ProductDetails
import com.adhderapp.android.adhder.data.SocialRepository
import com.adhderapp.android.adhder.databinding.FragmentGiftGemPurchaseBinding
import com.adhderapp.android.adhder.helpers.PurchaseHandler
import com.adhderapp.android.adhder.helpers.PurchaseTypes
import com.adhderapp.android.adhder.models.members.Member
import com.adhderapp.android.adhder.ui.GemPurchaseOptionsView
import com.adhderapp.android.adhder.ui.fragments.BaseFragment
import com.adhderapp.common.adhder.helpers.ExceptionHandler
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject

@AndroidEntryPoint
class GiftPurchaseGemsFragment : BaseFragment<FragmentGiftGemPurchaseBinding>() {
    @Inject
    lateinit var socialRepository: SocialRepository

    override var binding: FragmentGiftGemPurchaseBinding? = null

    override fun createBinding(
        inflater: LayoutInflater,
        container: ViewGroup?
    ): FragmentGiftGemPurchaseBinding {
        return FragmentGiftGemPurchaseBinding.inflate(inflater, container, false)
    }

    var giftedMember: Member? = null
        @SuppressLint("SetTextI18n")
        set(value) {
            field = value
            field?.let {
                binding?.avatarView?.setAvatar(it)
                binding?.displayNameTextview?.username = it.profile?.name
                binding?.displayNameTextview?.tier = it.contributor?.level ?: 0
                binding?.usernameTextview?.text = "@${it.username}"
            }
        }

    private var purchaseHandler: PurchaseHandler? = null

    fun setupCheckout() {
        CoroutineScope(Dispatchers.IO).launch(ExceptionHandler.coroutine()) {
            val skus = purchaseHandler?.getAllGemSKUs()
            withContext(Dispatchers.Main) {
                for (sku in skus ?: emptyList()) {
                    updateButtonLabel(sku, sku.oneTimePurchaseOfferDetails?.formattedPrice ?: "")
                }
            }
        }
    }

    fun setPurchaseHandler(handler: PurchaseHandler?) {
        this.purchaseHandler = handler
    }

    private fun updateButtonLabel(
        sku: ProductDetails,
        price: String
    ) {
        val matchingView: GemPurchaseOptionsView? =
            when (sku.productId) {
                PurchaseTypes.PURCHASE_4_GEMS -> binding?.gems4View
                PurchaseTypes.PURCHASE_21_GEMS -> binding?.gems21View
                PurchaseTypes.PURCHASE_42_GEMS -> binding?.gems42View
                PurchaseTypes.PURCHASE_84_GEMS -> binding?.gems84View
                else -> return
            }
        if (matchingView != null) {
            matchingView.setPurchaseButtonText(price)
            matchingView.setOnPurchaseClickListener {
                purchaseGems(sku)
            }
            matchingView.sku = sku
        }
    }

    private fun purchaseGems(sku: ProductDetails) {
        giftedMember?.id?.let {
            activity?.let { it1 -> purchaseHandler?.purchase(it1, sku, it, giftedMember?.username) }
        }
    }
}
