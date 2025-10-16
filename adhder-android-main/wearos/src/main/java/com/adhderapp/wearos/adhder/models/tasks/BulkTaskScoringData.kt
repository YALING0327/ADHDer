package com.adhderapp.wearos.adhder.models.tasks

import com.adhderapp.shared.adhder.models.responses.TaskDirectionData
import com.adhderapp.wearos.adhder.models.user.Buffs
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
class BulkTaskScoringData {
    @Json(name = "con")
    var constitution: Int? = null

    @Json(name = "str")
    var strength: Int? = null

    @Json(name = "per")
    var per: Int? = null

    @Json(name = "int")
    var intelligence: Int? = null
    var buffs: Buffs? = null
    var points: Int? = null
    var lvl: Int? = null

    @Json(name = "class")
    var habitClass: String? = null
    var gp: Double? = null
    var exp: Double? = null
    var mp: Double? = null
    var hp: Double? = null

    var tasks: List<TaskDirectionData> = listOf()
}
