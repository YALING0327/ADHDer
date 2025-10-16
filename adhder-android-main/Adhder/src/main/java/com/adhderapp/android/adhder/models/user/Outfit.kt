package com.adhderapp.android.adhder.models.user

import com.google.gson.annotations.SerializedName
import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.shared.adhder.models.AvatarOutfit
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Outfit : RealmObject(), BaseObject, AvatarOutfit {
    override var armor: String = ""
    override var back: String = ""
    override var body: String = ""
    override var head: String = ""
    override var shield: String = ""
    override var weapon: String = ""

    @SerializedName("eyewear")
    override var eyeWear: String = ""
    override var headAccessory: String = ""
}
