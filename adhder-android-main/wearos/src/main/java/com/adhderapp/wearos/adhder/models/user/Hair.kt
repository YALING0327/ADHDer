package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarHair
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Hair : AvatarHair {
    override var mustache: Int = 0
    override var beard: Int = 0
    override var bangs: Int = 0
    override var base: Int = 0
    override var flower: Int = 0
    override var color: String? = null
}
