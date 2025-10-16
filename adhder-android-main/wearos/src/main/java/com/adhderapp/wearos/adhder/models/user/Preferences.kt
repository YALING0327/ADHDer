package com.adhderapp.wearos.adhder.models.user

import com.adhderapp.shared.adhder.models.AvatarPreferences
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Preferences : AvatarPreferences {
    override var hair: Hair? = null
    override var costume: Boolean = false
    override var sleep: Boolean = false
    override var shirt: String? = null
    override var skin: String? = null
    override var size: String? = null
    override var background: String? = null
    override var chair: String? = null
    override var disableClasses: Boolean = false
}
