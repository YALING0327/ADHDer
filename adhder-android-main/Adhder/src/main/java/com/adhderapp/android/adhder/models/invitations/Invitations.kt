package com.adhderapp.android.adhder.models.invitations

import com.adhderapp.android.adhder.models.BaseObject
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Invitations : RealmObject(), BaseObject {
    var party: PartyInvite? = null
    var parties: RealmList<PartyInvite>? = null
    var guilds: RealmList<GuildInvite>? = null

    fun removeInvitation(groupID: String) {
        if (party?.id == groupID) {
            party = null
        }

        guilds?.removeAll {
            it.id == groupID
        }

        parties?.removeAll {
            it.id == groupID
        }
    }
}
