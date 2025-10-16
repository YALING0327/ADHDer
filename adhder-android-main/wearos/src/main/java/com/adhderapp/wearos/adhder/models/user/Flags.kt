package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarFlags
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Flags : AvatarFlags {
    override var classSelected: Boolean = false
}
