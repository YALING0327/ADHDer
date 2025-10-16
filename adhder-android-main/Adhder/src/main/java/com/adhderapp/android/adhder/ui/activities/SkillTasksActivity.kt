package com.adhderapp.android.adhder.ui.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.SparseArray
import android.view.MenuItem
import android.view.View
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.google.android.material.tabs.TabLayoutMediator
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.databinding.ActivitySkillTasksBinding
import com.adhderapp.android.adhder.models.tasks.Task
import com.adhderapp.android.adhder.ui.fragments.skills.SkillTasksRecyclerViewFragment
import com.adhderapp.shared.adhder.models.tasks.TaskType
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class SkillTasksActivity : BaseActivity() {
    private lateinit var binding: ActivitySkillTasksBinding

    @Inject
    lateinit var taskRepository: TaskRepository

    internal var viewFragmentsDictionary = SparseArray<SkillTasksRecyclerViewFragment>()

    override fun getLayoutResId(): Int {
        return R.layout.activity_skill_tasks
    }

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setupToolbar(findViewById(R.id.toolbar))
        loadTaskLists()
    }

    override fun getContentView(layoutResId: Int?): View {
        binding = ActivitySkillTasksBinding.inflate(layoutInflater)
        return binding.root
    }

    private fun loadTaskLists() {
        val statePagerAdapter =
            object : FragmentStateAdapter(supportFragmentManager, lifecycle) {
                override fun createFragment(position: Int): Fragment {
                    val fragment = SkillTasksRecyclerViewFragment()
                    fragment.taskType =
                        when (position) {
                            0 -> TaskType.HABIT
                            1 -> TaskType.DAILY
                            else -> TaskType.TODO
                        }
                    fragment.onTaskSelection = {
                        taskSelected(it)
                    }
                    viewFragmentsDictionary.put(position, fragment)
                    return fragment
                }

                override fun getItemCount(): Int {
                    return 3
                }
            }
        binding.viewPager.adapter = statePagerAdapter
        TabLayoutMediator(binding.tabLayout, binding.viewPager) { tab, position ->
            tab.text =
                when (position) {
                    0 -> getString(R.string.habits)
                    1 -> getString(R.string.dailies)
                    2 -> getString(R.string.todos)
                    else -> ""
                }
        }.attach()
        statePagerAdapter.notifyDataSetChanged()
    }

    fun taskSelected(task: Task) {
        val resultIntent = Intent()
        resultIntent.putExtra("taskID", task.id)
        setResult(Activity.RESULT_OK, resultIntent)
        finish()
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return if (item.itemId == android.R.id.home) {
            onBackPressed()
            true
        } else {
            super.onOptionsItemSelected(item)
        }
    }
}
