package com.adhderapp.android.adhder.ui.activities

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.activity.SystemBarStyle
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import androidx.fragment.app.Fragment
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.extensions.setNavigationBarDarkIcons
import com.adhderapp.android.adhder.extensions.updateStatusBarColor
import com.adhderapp.android.adhder.ui.fragments.purchases.GemsPurchaseFragment
import com.adhderapp.android.adhder.ui.fragments.purchases.SubscriptionFragment
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class GemPurchaseActivity : PurchaseActivity() {
    private var showSubscription: Boolean = false

    override fun getLayoutResId(): Int {
        return R.layout.activity_gem_purchase
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        navigationBarStyle = SystemBarStyle.dark(ContextCompat.getColor(this, R.color.brand_200))
        showSubscription = !(intent.extras?.containsKey("openSubscription") == true && intent.extras?.getBoolean("openSubscription") == false)
        super.onCreate(savedInstanceState)

        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        if (showSubscription) {
            setupToolbar(toolbar, Color.WHITE, ContextCompat.getColor(this, R.color.brand_300))
        } else {
            setupToolbar(toolbar)
        }

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setDisplayShowHomeEnabled(true)
        supportActionBar?.title = ""

        if (showSubscription) {
            createFragment(true)
            toolbar.title = getString(R.string.subscription)
        } else {
            createFragment(false)
        }
    }

    override fun onResume() {
        super.onResume()
        val controller = WindowCompat.getInsetsController(window, window.decorView)
        controller.isAppearanceLightNavigationBars = false

        if (showSubscription) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                controller.isAppearanceLightStatusBars = false
                window.setNavigationBarDarkIcons(false)
            } else {
                window.updateStatusBarColor(ContextCompat.getColor(this, R.color.brand_300), false)
            }
            findViewById<View>(R.id.appbar).setBackgroundColor(ContextCompat.getColor(this, R.color.brand_300))
        }
    }

    private fun createFragment(showSubscription: Boolean) {
        val fragment =
            if (showSubscription) {
                SubscriptionFragment()
            } else {
                GemsPurchaseFragment()
            }
        supportFragmentManager
            .beginTransaction()
            .replace(R.id.fragment_container, fragment as Fragment)
            .commit()
    }
}
