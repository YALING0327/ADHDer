package com.adhderapp.android.adhder.models.inventory

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class QuestProgressCollect : RealmObject(), BaseObject {
    var key: String? = null
    var count = 0
}
