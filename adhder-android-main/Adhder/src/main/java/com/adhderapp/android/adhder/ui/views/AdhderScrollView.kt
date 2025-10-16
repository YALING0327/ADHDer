package com.adhderapp.android.adhder.ui.views

import android.content.Context
import android.util.AttributeSet
import android.view.ViewGroup
import androidx.core.view.children
import androidx.core.widget.NestedScrollView
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.extensions.applyScrollContentWindowInsets

class AdhderScrollView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : NestedScrollView(context, attrs) {
    private var skipDirectChild = false

    init {
        context.theme?.obtainStyledAttributes(attrs, R.styleable.AdhderScrollView, 0, 0)?.let {
            skipDirectChild = it.getBoolean(R.styleable.AdhderScrollView_skipDirectchild, false)
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        var paddedChildren = children
        if (skipDirectChild) {
            paddedChildren = (paddedChildren.firstOrNull() as? ViewGroup)?.children ?: emptySequence()
        }
        paddedChildren.forEach {
            applyScrollContentWindowInsets(it,
                applyBottom = paddedChildren.lastOrNull() == it)
        }
    }
}