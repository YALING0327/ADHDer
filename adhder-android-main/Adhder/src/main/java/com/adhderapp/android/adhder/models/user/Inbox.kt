package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Inbox : RealmObject(), BaseObject {
    var optOut: Boolean = false
    var blocks: RealmList<String> = RealmList()
    var newMessages: Int = 0
    var hasUserSeenInbox: Boolean = false
}
