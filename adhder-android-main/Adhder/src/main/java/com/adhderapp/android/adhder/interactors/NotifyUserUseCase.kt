package com.adhderapp.android.adhder.interactors

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.text.SpannableStringBuilder
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.util.Pair
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.models.user.Stats
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.ui.activities.BaseActivity
import com.adhderapp.android.adhder.ui.views.AdhderIconsHelper
import com.adhderapp.android.adhder.ui.views.AdhderSnackbar
import com.adhderapp.android.adhder.ui.views.AdhderSnackbar.SnackbarDisplayType
import java.text.NumberFormat
import javax.inject.Inject
import kotlin.math.abs

class NotifyUserUseCase
@Inject
constructor(
    private val levelUpUseCase: LevelUpUseCase,
    private val userRepository: UserRepository
) : UseCase<NotifyUserUseCase.RequestValues, Stats?>() {
    override suspend fun run(requestValues: RequestValues): Stats? {
        if (requestValues.user == null) {
            return null
        }
        val pair =
            getNotificationAndAddStatsToUser(
                requestValues.context,
                requestValues.xp,
                requestValues.hp,
                requestValues.gold,
                requestValues.mp,
                requestValues.questDamage,
                requestValues.user
            )
        val view = pair.first
        val type = pair.second
        if (view != null && type != null) {
            AdhderSnackbar.showSnackbar(requestValues.snackbarTargetView, null, null, view, type)
        }
        if (requestValues.hasLeveledUp == true) {
            levelUpUseCase.callInteractor(
                LevelUpUseCase.RequestValues(
                    requestValues.user,
                    requestValues.level,
                    requestValues.context,
                    requestValues.snackbarTargetView
                )
            )
            userRepository.retrieveUser(true)
        }
        return requestValues.user.stats
    }

    class RequestValues(
        val context: BaseActivity,
        val snackbarTargetView: ViewGroup,
        val user: User?,
        val xp: Double?,
        val hp: Double?,
        val gold: Double?,
        val mp: Double?,
        val questDamage: Double?,
        val hasLeveledUp: Boolean?,
        val level: Int?
    ) : UseCase.RequestValues

    companion object {
        val formatter =
            NumberFormat.getInstance().apply {
                this.minimumFractionDigits = 0
                this.maximumFractionDigits = 2
            }

        fun getNotificationAndAddStatsToUser(
            context: Context,
            xp: Double?,
            hp: Double?,
            gold: Double?,
            mp: Double?,
            questDamage: Double?,
            user: User?
        ): Pair<View, SnackbarDisplayType> {
            var displayType = SnackbarDisplayType.SUCCESS

            val container = LinearLayout(context)
            container.orientation = LinearLayout.HORIZONTAL

            if (xp != null && xp > 0) {
                container.addView(
                    createTextView(
                        context,
                        xp,
                        AdhderIconsHelper.imageOfExperience()
                    )
                )
            }
            if (hp != null && hp != 0.0) {
                if (hp < 0) {
                    displayType = SnackbarDisplayType.FAILURE
                }
                container.addView(
                    createTextView(
                        context,
                        hp,
                        AdhderIconsHelper.imageOfHeartDarkBg()
                    )
                )
            }
            if (gold != null && gold != 0.0) {
                container.addView(createTextView(context, gold, AdhderIconsHelper.imageOfGold()))
                if (gold < 0) {
                    displayType = SnackbarDisplayType.FAILURE
                }
            }
            if (mp != null && mp > 0 && user?.hasClass == true) {
                container.addView(createTextView(context, mp, AdhderIconsHelper.imageOfMagic()))
            }
            if (questDamage != null && questDamage > 0) {
                container.addView(
                    createTextView(
                        context,
                        questDamage,
                        AdhderIconsHelper.imageOfDamage()
                    )
                )
            }

            val childCount = container.childCount
            if (childCount == 0) {
                return Pair(null, displayType)
            }
            val padding = context.resources.getDimension(R.dimen.spacing_medium).toInt()
            (1 until childCount)
                .map { container.getChildAt(it) }
                .forEach { it.setPadding(padding, 0, 0, 0) }

            return Pair(container, displayType)
        }

        private fun createTextView(
            context: Context,
            value: Double,
            icon: Bitmap
        ): View {
            val textView = TextView(context)
            val iconDrawable = BitmapDrawable(context.resources, icon)
            textView.setCompoundDrawablesWithIntrinsicBounds(iconDrawable, null, null, null)
            val text: String =
                if (value > 0) {
                    " + " + formatter.format(abs(value))
                } else {
                    " - " + formatter.format(abs(value))
                }
            textView.text = text
            textView.gravity = Gravity.CENTER_VERTICAL
            textView.setTextColor(ContextCompat.getColor(context, R.color.white))
            return textView
        }

        private fun formatValue(value: Double): String {
            return if (value >= 0) {
                " + " + formatter.format(abs(value))
            } else {
                " - " + formatter.format(abs(value))
            }
        }

        fun getNotificationAndAddStatsToUserAsText(
            xp: Double?,
            hp: Double?,
            gold: Double?,
            mp: Double?
        ): Pair<SpannableStringBuilder, SnackbarDisplayType> {
            val builder = SpannableStringBuilder()
            var displayType = SnackbarDisplayType.NORMAL

            if (xp != null && xp != 0.0) {
                builder.append(formatValue(xp)).append(" Exp")
            }
            if (hp != null && hp != 0.0) {
                if (hp < 0) {
                    displayType = SnackbarDisplayType.FAILURE
                }
                builder.append(formatValue(hp)).append(" Health")
            }
            if (gold != null && gold != 0.0) {
                if (gold < 0) {
                    displayType = SnackbarDisplayType.FAILURE
                }
                builder.append(formatValue(gold)).append(" Gold")
            }
            if (mp != null && mp != 0.0) {
                builder.append(formatValue(mp)).append(" Exp").append(" Mana")
            }

            return Pair(builder, displayType)
        }
    }
}
