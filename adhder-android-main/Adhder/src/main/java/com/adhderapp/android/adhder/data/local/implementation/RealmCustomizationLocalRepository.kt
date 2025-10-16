package com.adhderapp.android.adhder.data.local.implementation

import com.adhderapp.android.adhder.data.local.CustomizationLocalRepository
import com.adhderapp.android.adhder.models.inventory.Customization
import io.realm.Realm
import io.realm.kotlin.toFlow
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.filter
import java.util.Date

class RealmCustomizationLocalRepository(realm: Realm) :
    RealmContentLocalRepository(realm),
    CustomizationLocalRepository {
    override fun getCustomizations(
        type: String,
        category: String?,
        onlyAvailable: Boolean
    ): Flow<List<Customization>> {
        var query =
            realm.where(Customization::class.java)
                .equalTo("type", type)
                .equalTo("category", category)
        if (onlyAvailable) {
            val today = Date()
            query =
                query
                    .beginGroup()
                    .beginGroup()
                    .lessThanOrEqualTo("availableFrom", today)
                    .greaterThanOrEqualTo("availableUntil", today)
                    .endGroup()
                    .or()
                    .beginGroup()
                    .isNull("availableFrom")
                    .isNull("availableUntil")
                    .endGroup()
                    .endGroup()
        }
        return query
            .sort("customizationSet")
            .findAll()
            .toFlow()
            .filter { it.isLoaded }
    }
}
