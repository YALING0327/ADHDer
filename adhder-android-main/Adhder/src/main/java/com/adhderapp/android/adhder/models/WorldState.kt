package com.adhderapp.android.adhder.models

import com.google.gson.annotations.SerializedName
import com.adhderapp.android.adhder.models.inventory.QuestProgress
import com.adhderapp.android.adhder.models.inventory.QuestRageStrike
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class WorldState : RealmObject(), BaseObject {
    @PrimaryKey
    var id = "adhder"
    var worldBossKey: String = ""
    var worldBossActive: Boolean = false
    var progress: QuestProgress? = null
    var rageStrikes: RealmList<QuestRageStrike>? = null

    var npcImageSuffix: String? = null

    var currentEvent: WorldStateEvent? = null

    @SerializedName("currentEventList")
    var events: RealmList<WorldStateEvent> = RealmList()

    fun findNpcImageSuffix(): String? {
        if (!npcImageSuffix.isNullOrBlank()) {
            return npcImageSuffix
        } else if (!currentEvent?.npcImageSuffix.isNullOrBlank()) {
            return currentEvent?.npcImageSuffix
        } else {
            for (event in events) {
                if (!event.npcImageSuffix.isNullOrBlank()) {
                    return event.npcImageSuffix
                }
            }
        }
        return null
    }

    fun getCurrentSeason(): String? {
        return events.firstOrNull { it?.season != null }?.season ?: currentEvent?.season
    }
}
