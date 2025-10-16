package com.adhderapp.android.adhder.ui.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.SocialRepository
import com.adhderapp.android.adhder.databinding.ActivitySkillMembersBinding
import com.adhderapp.android.adhder.ui.adapter.social.PartyMemberRecyclerViewAdapter
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import com.adhderapp.common.adhder.helpers.ExceptionHandler
import com.adhderapp.common.adhder.helpers.launchCatching
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class SkillMemberActivity : BaseActivity() {
    private lateinit var binding: ActivitySkillMembersBinding
    private var viewAdapter: PartyMemberRecyclerViewAdapter? = null

    @Inject
    lateinit var socialRepository: SocialRepository

    @Inject
    lateinit var userViewModel: MainUserViewModel

    override fun getLayoutResId(): Int {
        return R.layout.activity_skill_members
    }

    override fun getContentView(layoutResId: Int?): View {
        binding = ActivitySkillMembersBinding.inflate(layoutInflater)
        return binding.root
    }

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setupToolbar(findViewById(R.id.toolbar))
        loadMemberList()
        title = getString(R.string.choose_member)
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    private fun loadMemberList() {
        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        viewAdapter = PartyMemberRecyclerViewAdapter()
        viewAdapter?.onUserClicked = {
            lifecycleScope.launchCatching {
                val resultIntent = Intent()
                resultIntent.putExtra("member_id", it)
                setResult(Activity.RESULT_OK, resultIntent)
                finish()
            }
        }
        binding.recyclerView.adapter = viewAdapter

        lifecycleScope.launch(ExceptionHandler.coroutine()) {
            userRepository.getUser()
                .map { it?.party?.id }
                .filterNotNull()
                .take(1)
                .onEach { socialRepository.retrievePartyMembers(it, true) }
                .flatMapLatest { socialRepository.getPartyMembers(it) }
                .collect { viewAdapter?.data = it }
        }
    }
}
