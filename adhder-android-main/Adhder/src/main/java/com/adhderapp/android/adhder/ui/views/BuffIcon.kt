package com.adhderapp.android.adhder.ui.views

import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.asImageBitmap

@Composable
fun BuffIcon(
    buffed: Boolean?,
    modifier: Modifier = Modifier
) {
    if (buffed == true) {
        Image(AdhderIconsHelper.imageOfBuffIcon().asImageBitmap(), null, modifier = modifier)
    }
}
