package com.adhderapp.android.adhder.extensions

import android.app.Activity
import android.content.Context
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import com.adhderapp.common.adhder.helpers.launchCatching
import kotlinx.coroutines.CoroutineScope

fun Activity.hideKeyboard() {
    val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.hideSoftInputFromWindow(window.decorView.windowToken, 0)
}

fun AppCompatActivity.lifecycleLaunchWhen(state: Lifecycle.State, function: suspend CoroutineScope.() -> Unit) {
    lifecycleScope.launchCatching {
        repeatOnLifecycle(state, function)
    }
}
