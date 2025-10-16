package com.adhderapp.android.adhder.extensions

import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.ui.views.dialogs.AdhderAlertDialog

fun AdhderAlertDialog.addOkButton(
    isPrimary: Boolean = true,
    listener: ((AdhderAlertDialog, Int) -> Unit)? = null
) {
    this.addButton(R.string.ok, isPrimary, false, true, listener)
}

fun AdhderAlertDialog.addCloseButton(
    isPrimary: Boolean = false,
    listener: ((AdhderAlertDialog, Int) -> Unit)? = null
) {
    this.addButton(R.string.close, isPrimary, false, true, listener)
}

fun AdhderAlertDialog.addCancelButton(
    isPrimary: Boolean = false,
    listener: ((AdhderAlertDialog, Int) -> Unit)? = null
) {
    this.addButton(R.string.cancel, isPrimary, false, true, listener)
}
