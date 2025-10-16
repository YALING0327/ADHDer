package com.adhderapp.android.adhder.interactors

import android.graphics.Bitmap
import androidx.core.graphics.scale
import com.adhderapp.android.adhder.ui.activities.BaseActivity
import com.adhderapp.common.adhder.views.AvatarView
import com.adhderapp.shared.adhder.models.Avatar
import javax.inject.Inject

class ShareAvatarUseCase
@Inject
constructor() : UseCase<ShareAvatarUseCase.RequestValues, Unit>() {
    override suspend fun run(requestValues: RequestValues) {
        val avatarView =
            AvatarView(
                requestValues.activity,
                showBackground = true,
                showMount = true,
                showPet = true
            )
        avatarView.setAvatar(requestValues.avatar)
        var sharedImage: Bitmap? = null
        avatarView.onAvatarImageReady { image ->
            sharedImage = image?.scale(image.width * 3, image.height * 3, false)
            requestValues.activity.shareContent(
                requestValues.identifier,
                requestValues.message,
                sharedImage
            )
        }
    }

    class RequestValues(
        val activity: BaseActivity,
        val avatar: Avatar,
        val message: String?,
        val identifier: String
    ) : UseCase.RequestValues
}
