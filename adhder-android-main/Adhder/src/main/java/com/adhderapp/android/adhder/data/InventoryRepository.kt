package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.inventory.Egg
import com.adhderapp.android.adhder.models.inventory.Equipment
import com.adhderapp.android.adhder.models.inventory.EquipmentSet
import com.adhderapp.android.adhder.models.inventory.Food
import com.adhderapp.android.adhder.models.inventory.HatchingPotion
import com.adhderapp.android.adhder.models.inventory.Item
import com.adhderapp.android.adhder.models.inventory.Mount
import com.adhderapp.android.adhder.models.inventory.Pet
import com.adhderapp.android.adhder.models.inventory.Quest
import com.adhderapp.android.adhder.models.inventory.QuestContent
import com.adhderapp.android.adhder.models.responses.BuyResponse
import com.adhderapp.android.adhder.models.shops.Shop
import com.adhderapp.android.adhder.models.shops.ShopItem
import com.adhderapp.android.adhder.models.user.Items
import com.adhderapp.android.adhder.models.user.OwnedItem
import com.adhderapp.android.adhder.models.user.OwnedMount
import com.adhderapp.android.adhder.models.user.OwnedPet
import com.adhderapp.android.adhder.models.user.User
import com.adhderapp.shared.adhder.models.responses.FeedResponse
import kotlinx.coroutines.flow.Flow

interface InventoryRepository : BaseRepository {
    fun getArmoireRemainingCount(): Flow<Int>

    fun getInAppRewards(): Flow<List<ShopItem>>

    fun getInAppReward(key: String): Flow<ShopItem>

    fun getOwnedEquipment(): Flow<List<Equipment>>

    fun getMounts(): Flow<List<Mount>>

    fun getOwnedMounts(): Flow<List<OwnedMount>>

    fun getPets(): Flow<List<Pet>>

    fun getOwnedPets(): Flow<List<OwnedPet>>

    fun getQuestContent(key: String): Flow<QuestContent?>

    fun getQuestContent(keys: List<String>): Flow<List<QuestContent>>

    fun getEquipment(searchedKeys: List<String>): Flow<List<Equipment>>

    suspend fun retrieveInAppRewards(): List<ShopItem>?

    fun getOwnedEquipment(type: String): Flow<List<Equipment>>

    fun getEquipmentType(
        type: String,
        set: String
    ): Flow<List<Equipment>>

    fun getOwnedItems(
        itemType: String,
        includeZero: Boolean = false
    ): Flow<List<OwnedItem>>

    fun getOwnedItems(includeZero: Boolean = false): Flow<Map<String, OwnedItem>>

    fun getEquipment(key: String): Flow<Equipment>

    suspend fun openMysteryItem(user: User?): Equipment?

    fun saveEquipment(equipment: Equipment)

    fun getMounts(
        type: String?,
        group: String?,
        color: String?
    ): Flow<List<Mount>>

    fun getPets(
        type: String?,
        group: String?,
        color: String?
    ): Flow<List<Pet>>

    fun updateOwnedEquipment(user: User)

    suspend fun changeOwnedCount(
        type: String,
        key: String,
        amountToAdd: Int
    )

    suspend fun sellItem(
        type: String,
        key: String
    ): User?

    suspend fun sellItem(item: OwnedItem): User?

    suspend fun equipGear(
        equipment: String,
        asCostume: Boolean
    ): Items?

    suspend fun equip(
        type: String,
        key: String
    ): Items?

    suspend fun feedPet(
        pet: Pet,
        food: Food
    ): FeedResponse?

    suspend fun hatchPet(
        egg: Egg,
        hatchingPotion: HatchingPotion,
        successFunction: () -> Unit
    ): Items?

    suspend fun inviteToQuest(quest: QuestContent): Quest?

    suspend fun buyItem(
        user: User?,
        id: String,
        value: Double,
        purchaseQuantity: Int
    ): BuyResponse?

    suspend fun retrieveShopInventory(identifier: String): Shop?

    suspend fun retrieveMarketGear(): Shop?

    suspend fun purchaseMysterySet(categoryIdentifier: String): Void?

    suspend fun purchaseHourglassItem(
        purchaseType: String,
        key: String
    ): Void?

    suspend fun purchaseQuest(key: String): Void?

    suspend fun purchaseSpecialSpell(key: String): Void?

    suspend fun purchaseItem(
        purchaseType: String,
        key: String,
        purchaseQuantity: Int
    ): Void?

    suspend fun togglePinnedItem(item: ShopItem): List<ShopItem>?

    fun getItems(
        itemClass: Class<out Item>,
        keys: Array<String>
    ): Flow<List<Item>>

    fun getItems(itemClass: Class<out Item>): Flow<List<Item>>

    fun getLatestMysteryItem(): Flow<Equipment>
    fun getLatestMysteryItemAndSet(): Flow<Pair<Equipment, EquipmentSet?>>

    fun getItem(
        type: String,
        key: String
    ): Flow<Item>

    fun getAvailableLimitedItems(): Flow<List<Item>>
}
