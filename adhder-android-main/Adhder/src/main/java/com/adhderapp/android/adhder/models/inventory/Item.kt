package com.adhderapp.android.adhder.models.inventory

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmModel
import io.realm.RealmObject
import java.util.Date

open class ItemEvent : RealmObject(), BaseObject {
    var start: Date? = null
    var end: Date? = null
}

interface Item : RealmModel {
    val type: String
    val key: String
    val text: String
    val value: Int
    var event: ItemEvent?
}
