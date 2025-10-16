package com.adhderapp.android.adhder.modules

import android.content.Context
import android.content.SharedPreferences
import com.adhderapp.android.adhder.api.MaintenanceApiService
import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.implementation.ApiClientImpl
import com.adhderapp.android.adhder.data.implementation.ApiClientImpl.Companion.createGsonFactory
import com.adhderapp.android.adhder.helpers.MainNotificationsManager
import com.adhderapp.android.adhder.helpers.NotificationsManager
import com.adhderapp.common.adhder.api.HostConfig
import com.adhderapp.common.adhder.helpers.KeyHelper
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.lang.ref.WeakReference
import javax.inject.Singleton

@InstallIn(SingletonComponent::class)
@Module
open class ApiModule {
    @Provides
    @Singleton
    fun providesHostConfig(
        sharedPreferences: SharedPreferences,
        keyHelper: KeyHelper?,
        @ApplicationContext context: Context
    ): HostConfig {
        return HostConfig(sharedPreferences, keyHelper, context)
    }

    @Provides
    fun providesGsonConverterFactory(): GsonConverterFactory {
        return createGsonFactory()
    }

    @Provides
    @Singleton
    fun providesPopupNotificationsManager(): NotificationsManager {
        return MainNotificationsManager()
    }

    @Provides
    @Singleton
    fun providesApiHelper(
        gsonConverter: GsonConverterFactory,
        hostConfig: HostConfig,
        notificationsManager: NotificationsManager,
        @ApplicationContext context: Context
    ): ApiClient {
        val apiClient =
            ApiClientImpl(
                gsonConverter,
                hostConfig,
                notificationsManager,
                context
            )
        notificationsManager.apiClient = WeakReference(apiClient)
        return apiClient
    }

    @Provides
    fun providesMaintenanceApiService(gsonConverter: GsonConverterFactory): MaintenanceApiService {
        val adapter =
            Retrofit.Builder()
                .baseUrl("https://adhder-assets.s3.amazonaws.com/mobileApp/endpoint/")
                .addConverterFactory(gsonConverter)
                .build()
        return adapter.create(MaintenanceApiService::class.java)
    }
}
