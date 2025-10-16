package com.adhderapp.android.adhder.models.inventory

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class EquipmentSet : RealmObject() {
    @PrimaryKey
    var key: String = ""
    var text: String = ""
    var pinType: String = ""
}
