package com.adhderapp.android.adhder.ui.fragments.preferences

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.preference.PreferenceFragmentCompat
import androidx.recyclerview.widget.RecyclerView
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.extensions.applyScrollContentWindowInsets
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import javax.inject.Inject

abstract class BasePreferencesFragment : PreferenceFragmentCompat() {
    @Inject
    lateinit var userRepository: UserRepository

    @Inject
    lateinit var userViewModel: MainUserViewModel

    @Inject
    lateinit var inventoryRepository: InventoryRepository

    internal open var user: User? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        userViewModel.user.observe(viewLifecycleOwner) { setUser(it) }
        return super.onCreateView(inflater, container, savedInstanceState)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view.findViewById<RecyclerView>(R.id.recycler_view)?.let {
            applyScrollContentWindowInsets(it)
        }
    }

    override fun onDestroy() {
        userRepository.close()
        super.onDestroy()
    }

    override fun onCreatePreferences(
        savedInstanceState: Bundle?,
        rootKey: String?
    ) {
        setPreferencesFromResource(R.xml.preferences_fragment, rootKey)
        setupPreferences()
    }

    protected abstract fun setupPreferences()

    open fun setUser(user: User?) {
        this.user = user
    }
}
