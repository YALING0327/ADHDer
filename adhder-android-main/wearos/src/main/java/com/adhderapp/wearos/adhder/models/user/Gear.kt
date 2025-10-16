package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarGear
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
open class Gear : AvatarGear {
    override var equipped: Outfit? = null
    override var costume: Outfit? = null
}
