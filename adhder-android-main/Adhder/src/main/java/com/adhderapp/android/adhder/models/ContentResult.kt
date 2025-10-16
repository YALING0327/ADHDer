package com.adhderapp.android.adhder.models

import com.adhderapp.android.adhder.models.inventory.Customization
import com.adhderapp.android.adhder.models.inventory.Egg
import com.adhderapp.android.adhder.models.inventory.Equipment
import com.adhderapp.android.adhder.models.inventory.EquipmentSet
import com.adhderapp.android.adhder.models.inventory.Food
import com.adhderapp.android.adhder.models.inventory.HatchingPotion
import com.adhderapp.android.adhder.models.inventory.Mount
import com.adhderapp.android.adhder.models.inventory.Pet
import com.adhderapp.android.adhder.models.inventory.QuestContent
import com.adhderapp.android.adhder.models.inventory.SpecialItem
import io.realm.RealmList

/**
 * Created by Negue on 15.07.2015.
 */
class ContentResult {
    var potion: Equipment? = null
    var armoire: Equipment? = null
    var gear: ContentGear? = null
    var quests = RealmList<QuestContent>()
    var eggs = RealmList<Egg>()
    var food = RealmList<Food>()
    var hatchingPotions = RealmList<HatchingPotion>()
    var pets = RealmList<Pet>()
    var mounts = RealmList<Mount>()
    var spells = RealmList<Skill>()
    var appearances = RealmList<Customization>()
    var backgrounds = RealmList<Customization>()
    var faq = RealmList<FAQArticle>()
    var special = RealmList<SpecialItem>()
    var mystery = RealmList<EquipmentSet>()
}
