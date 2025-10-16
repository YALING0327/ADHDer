package com.adhderapp.android.adhder.models.user

import com.adhderapp.android.adhder.models.BaseObject

interface OwnedObject : BaseObject {
    var userID: String?
    var key: String?
}
