package com.adhderapp.android.adhder.models.user

import com.google.gson.annotations.SerializedName
import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.android.adhder.models.auth.LocalAuthentication
import com.adhderapp.android.adhder.models.user.auth.SocialAuthentication
import com.adhderapp.shared.adhder.models.AvatarAuthentication
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class Authentication : RealmObject(), BaseObject, AvatarAuthentication {
    fun findFirstSocialEmail(): String? {
        for (auth in listOf(googleAuthentication, appleAuthentication, facebookAuthentication)) {
            if (auth?.emails?.isNotEmpty() == true) {
                return auth.emails.first()
            }
        }
        return null
    }

    var blocked: Boolean = false
    val hasPassword: Boolean
        get() = localAuthentication?.hasPassword == true

    @SerializedName("local")
    override var localAuthentication: LocalAuthentication? = null

    @SerializedName("google")
    var googleAuthentication: SocialAuthentication? = null

    @SerializedName("apple")
    var appleAuthentication: SocialAuthentication? = null

    @SerializedName("facebook")
    var facebookAuthentication: SocialAuthentication? = null

    val hasGoogleAuth: Boolean
        get() = googleAuthentication?.emails?.isEmpty() != true
    val hasAppleAuth: Boolean
        get() = appleAuthentication?.emails?.isEmpty() != true
    val hasFacebookAuth: Boolean
        get() = facebookAuthentication?.emails?.isEmpty() != true

    var timestamps: AuthenticationTimestamps? = null
}
