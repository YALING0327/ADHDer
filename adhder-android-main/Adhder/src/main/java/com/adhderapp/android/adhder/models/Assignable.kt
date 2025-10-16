package com.adhderapp.android.adhder.models

import com.adhderapp.shared.adhder.models.Avatar

interface Assignable {
    val id: String?
    val avatar: Avatar?
    val identifiableName: String
}
