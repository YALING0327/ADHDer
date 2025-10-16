package com.adhderapp.android.adhder.extensions

import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable

fun Bitmap.asDrawable(resources: Resources): Drawable {
    return BitmapDrawable(resources, this)
}
