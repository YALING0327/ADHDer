package com.adhderapp.android.adhder.ui.activities

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.core.content.edit
import androidx.preference.PreferenceManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.databinding.WidgetConfigureHabitButtonBinding
import com.adhderapp.android.adhder.ui.adapter.SkillTasksRecyclerViewAdapter
import com.adhderapp.android.adhder.widget.HabitButtonWidgetProvider
import com.adhderapp.common.adhder.helpers.ExceptionHandler
import com.adhderapp.shared.adhder.models.tasks.TaskType
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class HabitButtonWidgetActivity : BaseActivity() {
    private val job = SupervisorJob()

    private lateinit var binding: WidgetConfigureHabitButtonBinding

    @Inject
    lateinit var taskRepository: TaskRepository

    private var widgetId: Int = 0
    private var adapter: SkillTasksRecyclerViewAdapter? = null

    override fun getLayoutResId(): Int {
        return R.layout.widget_configure_habit_button
    }

    override fun getContentView(layoutResId: Int?): View {
        binding = WidgetConfigureHabitButtonBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intent = intent
        val extras = intent.extras
        if (extras != null) {
            widgetId =
                extras.getInt(
                    AppWidgetManager.EXTRA_APPWIDGET_ID,
                    AppWidgetManager.INVALID_APPWIDGET_ID
                )
        }

        // If this activity was started with an intent without an app widget ID,
        // finish with an error.
        if (widgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
        }

        var layoutManager: LinearLayoutManager? =
            binding.recyclerView.layoutManager as? LinearLayoutManager

        if (layoutManager == null) {
            layoutManager = LinearLayoutManager(this)

            binding.recyclerView.layoutManager = layoutManager
        }

        adapter = SkillTasksRecyclerViewAdapter()
        adapter?.onTaskSelection = {
            taskSelected(it.id)
        }
        binding.recyclerView.adapter = adapter

        CoroutineScope(Dispatchers.Main + job).launch(ExceptionHandler.coroutine()) {
            adapter?.data = taskRepository.getTasks(TaskType.HABIT, includedGroupIDs = emptyArray())
                .firstOrNull() ?: listOf()
        }
    }

    private fun taskSelected(taskId: String?) {
        finishWithSelection(taskId)
    }

    private fun finishWithSelection(selectedTaskId: String?) {
        storeSelectedTaskId(selectedTaskId)

        val resultValue = Intent()
        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        setResult(Activity.RESULT_OK, resultValue)
        finish()

        val intent =
            Intent(
                AppWidgetManager.ACTION_APPWIDGET_UPDATE,
                null,
                this,
                HabitButtonWidgetProvider::class.java
            )
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(widgetId))
        sendBroadcast(intent)
    }

    private fun storeSelectedTaskId(selectedTaskId: String?) {
        PreferenceManager.getDefaultSharedPreferences(this).edit {
            putString("habit_button_widget_$widgetId", selectedTaskId)
        }
    }
}
