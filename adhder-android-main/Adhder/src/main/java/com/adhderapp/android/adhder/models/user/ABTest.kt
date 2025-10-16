package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class ABTest : RealmObject(), BaseObject {
    var name: String = ""
    var group: String = ""
}
