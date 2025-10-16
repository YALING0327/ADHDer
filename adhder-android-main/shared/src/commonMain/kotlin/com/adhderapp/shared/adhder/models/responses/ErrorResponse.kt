package com.adhderapp.shared.adhder.models.responses

class ErrorResponse {
    var message: String? = null
    var errors: List<AdhderError>? = null
    val displayMessage: String
        get() {
            if (errors?.isNotEmpty() == true) {
                val error = errors?.get(0)
                if (error?.message?.isNotBlank() == true) {
                    return error.message ?: ""
                }
            }
            return message ?: ""
        }
}
