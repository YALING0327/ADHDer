package com.adhderapp.android.adhder.ui.views

import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.asImageBitmap

@Composable
fun ClassIcon(
    className: String?,
    hasClass: Boolean,
    modifier: Modifier = Modifier
) {
    if (hasClass) {
        val icon =
            when (className) {
                "warrior" -> AdhderIconsHelper.imageOfWarriorLightBg().asImageBitmap()
                "wizard" -> AdhderIconsHelper.imageOfMageLightBg().asImageBitmap()
                "healer" -> AdhderIconsHelper.imageOfHealerLightBg().asImageBitmap()
                "rogue" -> AdhderIconsHelper.imageOfRogueLightBg().asImageBitmap()
                else -> null
            }
        if (icon != null) {
            Image(bitmap = icon, "", modifier = modifier)
        }
    }
}
