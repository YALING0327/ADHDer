package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarItems
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Items : AvatarItems {
    override var gear: Gear? = null

    override var currentMount: String? = null
    override var currentPet: String? = null
}
