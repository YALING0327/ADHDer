package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class SubscriptionPlanConsecutive : RealmObject(), BaseObject {
    var trinkets = 0
    var gemCapExtra = 0
    var offset = 0
    var count = 0
}
