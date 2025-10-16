package com.adhderapp.android.adhder.ui.viewmodels.inventory.equipment

import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.models.user.Preferences
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import io.kotest.core.spec.style.WordSpec
import io.kotest.matchers.shouldBe
import io.mockk.clearMocks
import io.mockk.every
import io.mockk.mockk

class EquipmentOverviewViewModelTest : WordSpec({
    val mainUserViewmodel = mockk<MainUserViewModel>()
    val userRepository = mockk<UserRepository>()
    val inventoryRepository = mockk<InventoryRepository>()
    val viewModel = EquipmentOverviewViewModel(userRepository, mainUserViewmodel, inventoryRepository)
    "usesAutoEquip" should {
        "return true if user has it set" {
            every { mainUserViewmodel.user.value } returns
                User().apply {
                    preferences = Preferences()
                    preferences?.autoEquip = true
                }
            viewModel.usesAutoEquip shouldBe true
        }
        "return false if user does not use autoequip" {
            every { mainUserViewmodel.user.value } returns
                User().apply {
                    preferences = Preferences()
                    preferences?.autoEquip = false
                }
            viewModel.usesAutoEquip shouldBe false
        }
    }

    "usesCostume" should {
        "return true if user has it set" {
            every { mainUserViewmodel.user.value } returns
                User().apply {
                    preferences = Preferences()
                    preferences?.costume = true
                }
            viewModel.usesCostume shouldBe true
        }
        "return false if user does not use costume" {
            every { mainUserViewmodel.user.value } returns
                User().apply {
                    preferences = Preferences()
                    preferences?.costume = false
                }
            viewModel.usesCostume shouldBe false
        }
    }

    afterEach { clearMocks(mainUserViewmodel.user) }
})
