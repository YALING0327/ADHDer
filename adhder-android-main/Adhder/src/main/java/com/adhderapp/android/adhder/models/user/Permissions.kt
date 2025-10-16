package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmObject

open class Permissions : RealmObject(), BaseObject {
    var userSupport: Boolean = false
    var fullAccess: Boolean = false

    var moderator: Boolean = false
}
