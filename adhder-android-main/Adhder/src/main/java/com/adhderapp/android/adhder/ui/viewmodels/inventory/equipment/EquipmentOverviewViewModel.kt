package com.adhderapp.android.adhder.ui.viewmodels.inventory.equipment

import androidx.lifecycle.viewModelScope
import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.models.inventory.Equipment
import com.adhderapp.android.adhder.ui.viewmodels.BaseViewModel
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import com.adhderapp.common.adhder.helpers.launchCatching
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class EquipmentOverviewViewModel
@Inject
constructor(
    userRepository: UserRepository,
    userViewModel: MainUserViewModel,
    val inventoryRepository: InventoryRepository
) : BaseViewModel(userRepository, userViewModel) {
    val usesAutoEquip: Boolean
        get() = user.value?.preferences?.autoEquip == true
    val usesCostume: Boolean
        get() = user.value?.preferences?.costume == true

    fun getGear(
        key: String,
        onSuccess: (Equipment) -> Unit
    ) {
        viewModelScope.launchCatching {
            inventoryRepository.getEquipment(key).collect {
                onSuccess(it)
            }
        }
    }
}
