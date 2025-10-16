package com.adhderapp.android.adhder.data.local

import com.adhderapp.android.adhder.models.inventory.Customization
import kotlinx.coroutines.flow.Flow

interface CustomizationLocalRepository : ContentLocalRepository {
    fun getCustomizations(
        type: String,
        category: String?,
        onlyAvailable: Boolean
    ): Flow<List<Customization>>
}
