package com.adhderapp.android.adhder.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import android.widget.Toast
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.helpers.Analytics
import com.adhderapp.android.adhder.helpers.EventCategory
import com.adhderapp.android.adhder.helpers.HitType
import com.adhderapp.android.adhder.interactors.NotifyUserUseCase
import com.adhderapp.shared.adhder.models.responses.TaskScoringResult
import javax.inject.Inject

abstract class BaseWidgetProvider : AppWidgetProvider() {
    @Inject
    lateinit var userRepository: UserRepository

    protected var context: Context? = null

    /**
     * Returns number of cells needed for given size of the widget.<br></br>
     * see http://stackoverflow.com/questions/14270138/dynamically-adjusting-widgets-content-and-layout-to-the-size-the-user-defined-t
     *
     * @param size Widget size in dp.
     * @return Size in number of cells.
     */
    private fun getCellsForSize(size: Int): Int {
        var n = 2
        while (70 * n - 30 < size) {
            ++n
        }
        return n - 1
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        this.context = context
        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)

        appWidgetManager.partiallyUpdateAppWidget(
            appWidgetId,
            sizeRemoteViews(context, options, appWidgetId)
        )

        super.onAppWidgetOptionsChanged(
            context,
            appWidgetManager,
            appWidgetId,
            newOptions
        )
    }

    fun sizeRemoteViews(
        context: Context?,
        options: Bundle,
        widgetId: Int
    ): RemoteViews {
        this.context = context
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val minHeight =
            options
                .getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

        // First find out rows and columns based on width provided.
        val rows = getCellsForSize(minHeight)
        val columns = getCellsForSize(minWidth)
        val remoteViews = RemoteViews(context?.packageName, layoutResourceId())

        return configureRemoteViews(remoteViews, widgetId, columns, rows)
    }

    protected fun showToastForTaskDirection(
        context: Context,
        data: TaskScoringResult?
    ) {
        if (data != null) {
            val pair =
                NotifyUserUseCase.getNotificationAndAddStatsToUserAsText(
                    data.experienceDelta,
                    data.healthDelta,
                    data.goldDelta,
                    data.manaDelta
                )
            val toast = Toast.makeText(context, pair.first, Toast.LENGTH_LONG)
            toast.show()
        }
    }

    abstract fun layoutResourceId(): Int

    abstract fun configureRemoteViews(
        remoteViews: RemoteViews,
        widgetId: Int,
        columns: Int,
        rows: Int
    ): RemoteViews

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        val additionalData = HashMap<String, Any>()
        additionalData["identifier"] = this.javaClass.simpleName
        Analytics.sendEvent(
            "widgets",
            EventCategory.BEHAVIOUR,
            HitType.CREATE_WIDGET,
            additionalData
        )
    }

    override fun onDeleted(
        context: Context,
        appWidgetIds: IntArray
    ) {
        val additionalData = HashMap<String, Any>()
        additionalData["identifier"] = this.javaClass.simpleName
        Analytics.sendEvent(
            "widgets",
            EventCategory.BEHAVIOUR,
            HitType.REMOVE_WIDGET,
            additionalData
        )
        super.onDeleted(context, appWidgetIds)
    }
}
