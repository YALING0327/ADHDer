package com.adhderapp.android.adhder.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.colorResource
import androidx.core.content.ContextCompat
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.common.adhder.extensions.getThemeColor
import com.adhderapp.common.adhder.theme.AdhderColors
import com.adhderapp.common.adhder.theme.AdhderTheme

@Composable
fun AdhderColors.textPrimaryFor(task: Task?): Color {
    return colorResource(
        (if (isSystemInDarkTheme()) task?.extraExtraLightTaskColor else task?.extraDarkTaskColor)
            ?: R.color.text_primary
    )
}

@Composable
fun AdhderColors.textSecondaryFor(task: Task?): Color {
    return colorResource(
        (if (isSystemInDarkTheme()) task?.extraLightTaskColor else task?.lowSaturationTaskColor)
            ?: R.color.brand_sub_text
    )
}

@Composable
fun AdhderColors.primaryBackgroundFor(task: Task?): Color {
    return colorResource(
        (if (isSystemInDarkTheme()) task?.mediumTaskColor else task?.lightTaskColor)
            ?: R.color.brand_400
    )
}

@Composable
fun AdhderColors.windowBackgroundFor(task: Task?): Color {
    return (if (isSystemInDarkTheme()) task?.extraExtraDarkTaskColor else task?.extraExtraLightTaskColor)?.let {
        colorResource(
            it
        )
    } ?: windowBackground
}

@Composable
fun AdhderColors.contentBackgroundFor(task: Task?): Color {
    return (if (isSystemInDarkTheme()) task?.darkestTaskColor else task?.lightestTaskColor)?.let {
        colorResource(
            it
        )
    } ?: windowBackground
}

@Composable
fun AdhderColors.pixelArtBackground(hasIcon: Boolean): Color {
    return if (isSystemInDarkTheme()) {
        colorResource(if (hasIcon) R.color.gray_50 else R.color.gray_5)
    } else {
        colorResource(if (hasIcon) R.color.window_background else R.color.content_background_offset)
    }
}

@Composable
fun AdhderColors.basicTextColor(): Color {
    return colorResource(R.color.gray200_gray400)
}

@Composable
fun AdhderColors.basicButtonColor(): Color {
    return colorResource(R.color.gray700_gray10)
}

val AdhderTheme.colors: AdhderColors
    @Composable
    get() {
        val context = LocalContext.current
        return AdhderColors(
            windowBackground = Color(context.getThemeColor(R.attr.colorWindowBackground)),
            contentBackground = Color(context.getThemeColor(R.attr.colorContentBackground)),
            contentBackgroundOffset = Color(context.getThemeColor(R.attr.colorContentBackgroundOffset)),
            offsetBackground = Color(context.getThemeColor(R.attr.colorOffsetBackground)),
            textPrimary = Color(context.getThemeColor(R.attr.textColorPrimary)),
            textSecondary = Color(context.getThemeColor(R.attr.textColorSecondary)),
            textTertiary = Color(ContextCompat.getColor(context, R.color.text_ternary)),
            textQuad = Color(ContextCompat.getColor(context, R.color.text_quad)),
            textDimmed = Color(ContextCompat.getColor(context, R.color.text_dimmed)),
            tintedUiMain = Color(context.getThemeColor(R.attr.tintedUiMain)),
            tintedUiSub = Color(context.getThemeColor(R.attr.tintedUiSub)),
            tintedUiDetails = Color(context.getThemeColor(R.attr.tintedUiDetails)),
            pixelArtBackground = Color(context.getThemeColor(R.attr.colorContentBackground)),
            errorBackground = Color(ContextCompat.getColor(context, R.color.background_red)),
            errorColor = Color(ContextCompat.getColor(context, R.color.text_red)),
            successBackground = Color(ContextCompat.getColor(context, R.color.background_green)),
            successColor = Color(ContextCompat.getColor(context, R.color.text_green))
        )
    }
