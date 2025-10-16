package com.adhderapp.android.adhder.ui.activities

import android.graphics.PorterDuff
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.EditText
import androidx.core.content.ContextCompat
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.databinding.ActivityFixcharacterBinding
import com.adhderapp.android.adhder.models.user.Stats
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import com.adhderapp.android.adhder.ui.views.AdhderIconsHelper
import com.adhderapp.common.adhder.extensions.setTintWith
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class FixCharacterValuesActivity : BaseActivity() {
    private lateinit var binding: ActivityFixcharacterBinding

    @Inject
    lateinit var userViewModel: MainUserViewModel

    override fun getLayoutResId(): Int = R.layout.activity_fixcharacter

    override fun getContentView(layoutResId: Int?): View {
        binding = ActivityFixcharacterBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setTitle(R.string.fix_character_values)
        setupToolbar(binding.toolbar)

        userViewModel.user.observe(this) { user = it }

        setIconBackground(
            binding.healthIconBackgroundView,
            ContextCompat.getColor(this, R.color.red_500)
        )
        setIconBackground(
            binding.experienceIconBackgroundView,
            ContextCompat.getColor(this, R.color.yellow_500)
        )
        setIconBackground(
            binding.manaIconBackgroundView,
            ContextCompat.getColor(this, R.color.blue_500)
        )
        setIconBackground(
            binding.goldIconBackgroundView,
            ContextCompat.getColor(this, R.color.yellow_500)
        )
        setIconBackground(
            binding.streakIconBackgroundView,
            ContextCompat.getColor(this, R.color.separator)
        )

        binding.healthIconView.setImageBitmap(AdhderIconsHelper.imageOfHeartLightBg())
        binding.experienceIconView.setImageBitmap(AdhderIconsHelper.imageOfExperience())
        binding.manaIconView.setImageBitmap(AdhderIconsHelper.imageOfMagic())
        binding.goldIconView.setImageBitmap(AdhderIconsHelper.imageOfGold())
        binding.streakIconView.setImageResource(R.drawable.achievement_thermometer)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.menu_save, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        val id = item.itemId

        if (id == R.id.action_save_changes) {
            val userInfo = HashMap<String, Any>()
            userInfo["stats.hp"] = binding.healthEditText.getDoubleValue()
            userInfo["stats.exp"] = binding.experienceEditText.getDoubleValue()
            userInfo["stats.gp"] = binding.goldEditText.getDoubleValue()
            userInfo["stats.mp"] = binding.manaEditText.getDoubleValue()
            userInfo["stats.lvl"] = binding.levelEditText.getDoubleValue().toInt()
            userInfo["achievements.streak"] = binding.streakEditText.getDoubleValue().toInt()
            userViewModel.updateUser(userInfo)
            finish()
            return true
        }

        return super.onOptionsItemSelected(item)
    }

    private var user: User? = null
        set(value) {
            field = value
            if (value != null) {
                updateFields(value)
            }
        }

    private fun updateFields(user: User) {
        val stats = user.stats ?: return
        binding.healthEditText.setText(stats.hp.toString())
        binding.experienceEditText.setText(stats.exp.toString())
        binding.goldEditText.setText(stats.gp.toString())
        binding.manaEditText.setText(stats.mp.toString())
        binding.levelEditText.setText(stats.lvl.toString())
        binding.streakEditText.setText(user.streakCount.toString())

        when (stats.habitClass) {
            Stats.WARRIOR -> {
                setIconBackground(
                    binding.levelIconBackgroundView,
                    ContextCompat.getColor(this, R.color.red_500)
                )
                binding.levelIconView.setImageBitmap(AdhderIconsHelper.imageOfWarriorLightBg())
            }

            Stats.MAGE -> {
                setIconBackground(
                    binding.levelIconBackgroundView,
                    ContextCompat.getColor(this, R.color.blue_500)
                )
                binding.levelIconView.setImageBitmap(AdhderIconsHelper.imageOfMageLightBg())
            }

            Stats.HEALER -> {
                setIconBackground(
                    binding.levelIconBackgroundView,
                    ContextCompat.getColor(this, R.color.yellow_500)
                )
                binding.levelIconView.setImageBitmap(AdhderIconsHelper.imageOfHealerLightBg())
            }

            Stats.ROGUE -> {
                setIconBackground(
                    binding.levelIconBackgroundView,
                    ContextCompat.getColor(this, R.color.brand_500)
                )
                binding.levelIconView.setImageBitmap(AdhderIconsHelper.imageOfRogueLightBg())
            }
        }
    }

    private fun setIconBackground(
        view: View,
        color: Int
    ) {
        val backgroundDrawable = ContextCompat.getDrawable(this, R.drawable.layout_rounded_bg)
        backgroundDrawable?.setTintWith(color, PorterDuff.Mode.MULTIPLY)
        backgroundDrawable?.alpha = 50
        view.background = backgroundDrawable
    }

    private fun EditText.getDoubleValue(): Double {
        val stringValue = this.text.toString()
        return try {
            stringValue.toDouble()
        } catch (_: NumberFormatException) {
            0.0
        }
    }
}
