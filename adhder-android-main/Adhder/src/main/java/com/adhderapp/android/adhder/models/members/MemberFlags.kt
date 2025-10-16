package com.adhderapp.android.adhder.models.members

import com.adhderapp.shared.adhder.models.AvatarFlags
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class MemberFlags : RealmObject(), AvatarFlags {
    var chatShadowMuted: Boolean = false
    var chatRevoked: Boolean = false
    override var classSelected: Boolean = false
}
