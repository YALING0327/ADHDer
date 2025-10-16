package com.adhderapp.android.adhder.data.implementation

import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.CustomizationRepository
import com.adhderapp.android.adhder.data.local.CustomizationLocalRepository
import com.adhderapp.android.adhder.models.inventory.Customization
import com.adhderapp.android.adhder.modules.AuthenticationHandler
import kotlinx.coroutines.flow.Flow

class CustomizationRepositoryImpl(
    localRepository: CustomizationLocalRepository,
    apiClient: ApiClient,
    authenticationHandler: AuthenticationHandler
) : BaseRepositoryImpl<CustomizationLocalRepository>(
    localRepository,
    apiClient,
    authenticationHandler
),
    CustomizationRepository {
    override fun getCustomizations(
        type: String,
        category: String?,
        onlyAvailable: Boolean
    ): Flow<List<Customization>> {
        return localRepository.getCustomizations(type, category, onlyAvailable)
    }
}
