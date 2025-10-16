package com.adhderapp.android.adhder.models.inventory

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class QuestProgress : RealmObject(), BaseObject {
    var id: String? = null
    var key: String? = null
    var hp: Double = 0.0
    var rage: Double = 0.0
    var collectedItems: Int = 0
    var collect: RealmList<QuestProgressCollect>? = null
    var down: Float = 0.0f
    var up: Float = 0.0f
}
