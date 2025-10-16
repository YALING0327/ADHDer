package com.adhderapp.android.adhder.ui.views.dialogs

import android.content.Context
import com.adhderapp.android.adhder.extensions.addCloseButton
import com.adhderapp.android.adhder.models.inventory.QuestContent
import com.adhderapp.android.adhder.ui.views.shops.PurchaseDialogQuestContent

class DetailDialog(context: Context) : AdhderAlertDialog(context) {
    var quest: QuestContent? = null
        set(value) {
            field = value
            if (value == null) return

            val contentView = PurchaseDialogQuestContent(context)
            contentView.setQuestContentItem(value)
            setAdditionalContentView(contentView)
        }

    init {
        addCloseButton()
    }
}
