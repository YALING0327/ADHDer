package com.adhderapp.android.adhder.api

import com.adhderapp.shared.adhder.models.responses.MaintenanceResponse
import retrofit2.http.GET

interface MaintenanceApiService {
    @GET("maintenance-android.json")
    suspend fun getMaintenanceStatus(): MaintenanceResponse?

    @GET("deprecation-android.json")
    suspend fun getDepricationStatus(): MaintenanceResponse?
}
