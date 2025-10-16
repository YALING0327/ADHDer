package com.adhderapp.android.adhder.ui.views.shops

import android.content.Context
import android.widget.TextView
import com.adhderapp.android.adhder.databinding.PurchaseDialogBackgroundBinding
import com.adhderapp.android.adhder.models.shops.ShopItem
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.views.AvatarView
import com.adhderapp.common.adhder.views.PixelArtView
import com.adhderapp.shared.adhder.models.Avatar
import java.util.EnumMap

class PurchaseDialogBackgroundContent(context: Context) : PurchaseDialogContent(context) {
    val binding = PurchaseDialogBackgroundBinding.inflate(context.layoutInflater, this)
    override val imageView: PixelArtView
        get() = PixelArtView(context)
    override val titleTextView: TextView
        get() = binding.titleTextView

    override fun setItem(item: ShopItem) {
        binding.titleTextView.text = item.text
        binding.notesTextView.text = item.notes
    }

    fun setAvatarWithBackgroundPreview(
        avatar: Avatar,
        item: ShopItem
    ) {
        val layerMap = EnumMap<AvatarView.LayerType, String>(AvatarView.LayerType::class.java)
        layerMap[AvatarView.LayerType.BACKGROUND] = item.imageName?.removePrefix("icon_")

        binding.avatarView.setAvatar(avatar, layerMap)
    }
}
