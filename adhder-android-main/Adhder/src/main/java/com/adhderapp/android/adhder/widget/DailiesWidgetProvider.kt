package com.adhderapp.android.adhder.widget

import com.adhderapp.android.adhder.R

class DailiesWidgetProvider : TaskListWidgetProvider() {
    override val serviceClass: Class<*>
        get() = DailiesWidgetService::class.java
    override val providerClass: Class<*>
        get() = DailiesWidgetProvider::class.java
    override val titleResId: Int
        get() = R.string.dailies
}
