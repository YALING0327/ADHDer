package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.android.adhder.models.inventory.Equipment
import com.adhderapp.shared.adhder.models.AvatarGear
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Gear : RealmObject(), BaseObject, AvatarGear {
    var owned: RealmList<Equipment>? = null
    override var equipped: Outfit? = null
    override var costume: Outfit? = null
}
