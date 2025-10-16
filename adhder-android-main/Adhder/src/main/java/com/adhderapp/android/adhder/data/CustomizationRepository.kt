package com.adhderapp.android.adhder.data

import com.adhderapp.android.adhder.models.inventory.Customization
import kotlinx.coroutines.flow.Flow

interface CustomizationRepository : BaseRepository {
    fun getCustomizations(
        type: String,
        category: String?,
        onlyAvailable: Boolean
    ): Flow<List<Customization>>
}
