package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarBuffs
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Buffs : AvatarBuffs {
    override var con: Float? = null
    override var str: Float? = null
    override var per: Float? = null
    override var intelligence: Float? = null
    override var seafoam: Boolean? = null
    override var spookySparkles: Boolean? = null
    override var shinySeed: Boolean? = null
    override var snowball: Boolean? = null
    override var streaks: Boolean? = null
}
