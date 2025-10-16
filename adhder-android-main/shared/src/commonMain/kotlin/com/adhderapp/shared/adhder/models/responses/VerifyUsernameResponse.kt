package com.adhderapp.shared.adhder.models.responses

class VerifyUsernameResponse {
    var isUsable: Boolean = false
    var issues = emptyList<String>()
}
