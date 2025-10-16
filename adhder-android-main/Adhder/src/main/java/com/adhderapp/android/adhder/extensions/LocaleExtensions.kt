package com.adhderapp.android.adhder.extensions

import com.adhderapp.common.adhder.helpers.LanguageHelper
import java.util.Locale

fun Locale.getSystemDefault(): Locale {
    return LanguageHelper.systemLocale
}
