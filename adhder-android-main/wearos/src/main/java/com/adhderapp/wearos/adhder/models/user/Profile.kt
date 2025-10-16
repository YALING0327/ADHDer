package com.adhderapp.wearos.adhder.models.user

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class Profile {
    var name: String? = null
}
