package com.adhderapp.android.adhder.ui.views.dialogs

import android.content.Context
import androidx.compose.foundation.layout.size
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.unit.dp
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.adhderapp.common.adhder.extensions.dpToPx
import com.adhderapp.common.adhder.theme.AdhderTheme
import com.adhderapp.common.adhder.views.AdhderCircularProgressView

class AdhderProgressDialog(context: Context) : AdhderAlertDialog(context) {
    companion object {
        fun show(
            context: FragmentActivity,
            titleID: Int
        ): AdhderProgressDialog {
            return show(context, context.getString(titleID))
        }

        fun show(
            context: FragmentActivity,
            title: String?,
            dialogWidth: Int = 300
        ): AdhderProgressDialog {
            val dialog = AdhderProgressDialog(context)
            val composeView = ComposeView(context)
            dialog.setAdditionalContentView(composeView)
            composeView.setContent {
                AdhderTheme {
                    AdhderCircularProgressView(Modifier.size(60.dp))
                }
            }
            dialog.window?.let {
                dialog.additionalContentView?.setViewTreeSavedStateRegistryOwner(context)
                it.decorView.setViewTreeSavedStateRegistryOwner(context)
                dialog.additionalContentView?.setViewTreeLifecycleOwner(context)
                it.decorView.setViewTreeLifecycleOwner(context)
            }
            dialog.dialogWidth = dialogWidth.dpToPx(context)
            dialog.setTitle(title)
            dialog.enqueue()
            return dialog
        }
    }
}
