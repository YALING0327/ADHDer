package com.adhderapp.android.adhder.ui.views.dialogs

import android.content.Context
import com.adhderapp.android.adhder.databinding.DialogOpenMysteryitemBinding
import com.adhderapp.common.adhder.extensions.dpToPx
import com.adhderapp.common.adhder.extensions.layoutInflater

class OpenedMysteryitemDialog(context: Context) : AdhderAlertDialog(context) {
    val binding = DialogOpenMysteryitemBinding.inflate(context.layoutInflater)

    init {
        setAdditionalContentView(binding.root)
        dialogWidth = 302.dpToPx(context)
    }
}
