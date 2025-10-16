package com.adhderapp.android.adhder.ui.menu

import android.graphics.drawable.Drawable
import android.os.Bundle
import com.adhderapp.android.adhder.models.user.User

data class AdhderDrawerItem(
    var transitionId: Int,
    val identifier: String,
    val text: String,
    val icon: Drawable? = null,
    val isHeader: Boolean = false
) {
    constructor(transitionId: Int, identifier: String) : this(transitionId, identifier, "")

    var bundle: Bundle? = null
    var itemViewType: Int? = null
    var subtitle: String? = null
    var subtitleTextColor: Int? = null
    var pillText: String? = null
    var pillBackground: Drawable? = null
    var showBubble: Boolean = false
    var isVisible: Boolean = true
    var isEnabled: Boolean = true

    var user: User? = null
}
