package com.adhderapp.android.adhder.models

import io.realm.RealmModel

interface BaseObject : RealmModel

interface BaseMainObject : BaseObject {
    val realmClass: Class<out RealmModel>
    val primaryIdentifier: String?
    val primaryIdentifierName: String
}
