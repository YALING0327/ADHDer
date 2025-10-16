package com.adhderapp.android.adhder.interactors

import android.content.Context
import android.view.View
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.adhderapp.android.adhder.AdhderBaseApplication
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.databinding.PetImageviewBinding
import com.adhderapp.android.adhder.models.inventory.Egg
import com.adhderapp.android.adhder.models.inventory.HatchingPotion
import com.adhderapp.android.adhder.models.user.Items
import com.adhderapp.android.adhder.ui.views.BackgroundScene
import com.adhderapp.android.adhder.ui.views.dialogs.AdhderAlertDialog
import com.adhderapp.common.adhder.extensions.layoutInflater
import com.adhderapp.common.adhder.extensions.loadImage
import com.adhderapp.common.adhder.helpers.launchCatching
import com.adhderapp.common.adhder.theme.AdhderTheme
import kotlinx.coroutines.MainScope
import javax.inject.Inject

class HatchPetUseCase
@Inject
constructor(
    private val inventoryRepository: InventoryRepository
) : UseCase<HatchPetUseCase.RequestValues, Items?>() {
    override suspend fun run(requestValues: RequestValues): Items? {
        return inventoryRepository.hatchPet(requestValues.egg, requestValues.potion) {
            val petWrapper = PetImageviewBinding.inflate(requestValues.context.layoutInflater)
            val petKey = requestValues.egg.key + "-" + requestValues.potion.key
            petWrapper.petImageview.loadImage("stable_Pet-$petKey")
            val potionName = requestValues.potion.text
            val eggName = requestValues.egg.text
            val currentActivity =
                AdhderBaseApplication.getInstance(requestValues.context)?.currentActivity?.get()
            val dialog = AdhderAlertDialog(requestValues.context)
            if (currentActivity != null) {
                petWrapper.backgroundView.setContent {
                    AdhderTheme {
                        BackgroundScene(Modifier.clip(AdhderTheme.shapes.large))
                    }
                }
                dialog.window?.let {
                    petWrapper.root.setViewTreeSavedStateRegistryOwner(currentActivity)
                    it.decorView.setViewTreeSavedStateRegistryOwner(currentActivity)
                    petWrapper.root.setViewTreeLifecycleOwner(currentActivity)
                    it.decorView.setViewTreeLifecycleOwner(currentActivity)
                }
            }
            dialog.isCelebratory = true
            dialog.setTitle(
                requestValues.context.getString(
                    R.string.hatched_pet_title,
                    potionName,
                    eggName
                )
            )
            dialog.setAdditionalContentView(petWrapper.root)
            dialog.addButton(R.string.equip, true) { _, _ ->
                MainScope().launchCatching {
                    inventoryRepository.equip(
                        "pet",
                        requestValues.egg.key + "-" + requestValues.potion.key
                    )
                }
            }
            dialog.addButton(R.string.share, false) { hatchingDialog, _ ->
                MainScope().launchCatching {
                    SharePetUseCase().callInteractor(
                        SharePetUseCase.RequestValues(
                            petKey,
                            requestValues.context.getString(
                                R.string.share_hatched,
                                potionName,
                                eggName
                            ),
                            requestValues.context
                        )
                    )
                }
                hatchingDialog.dismiss()
            }
            dialog.setExtraCloseButtonVisibility(View.VISIBLE)
            dialog.enqueue()
        }
    }

    class RequestValues(val potion: HatchingPotion, val egg: Egg, val context: Context) :
        UseCase.RequestValues
}
