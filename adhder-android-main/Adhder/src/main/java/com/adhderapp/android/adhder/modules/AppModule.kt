package com.adhderapp.android.adhder.modules

import android.content.Context
import android.content.SharedPreferences
import android.content.res.Resources
import androidx.preference.PreferenceManager
import com.adhderapp.android.adhder.BuildConfig
import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.ContentRepository
import com.adhderapp.android.adhder.helpers.AppConfigManager
import com.adhderapp.android.adhder.helpers.ReviewManager
import com.adhderapp.android.adhder.helpers.SoundFileLoader
import com.adhderapp.android.adhder.helpers.notifications.PushNotificationManager
import com.adhderapp.common.adhder.helpers.KeyHelper
import com.adhderapp.common.adhder.helpers.KeyHelper.Companion.getInstance
import com.adhderapp.shared.adhder.HLogger
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import java.io.IOException
import java.security.KeyStore
import java.security.KeyStoreException
import java.security.NoSuchAlgorithmException
import java.security.cert.CertificateException
import javax.inject.Singleton

@InstallIn(SingletonComponent::class)
@Module
class AppModule {
    @Provides
    @Singleton
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences {
        return PreferenceManager.getDefaultSharedPreferences(context)
    }

    @Provides
    fun provideKeyStore(): KeyStore? {
        try {
            val keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
            return keyStore
        } catch (e: KeyStoreException) {
            HLogger.logException("KeyHelper", "Error initializing", e)
        } catch (e: CertificateException) {
            HLogger.logException("KeyHelper", "Error initializing", e)
        } catch (e: NoSuchAlgorithmException) {
            HLogger.logException("KeyHelper", "Error initializing", e)
        } catch (e: IOException) {
            HLogger.logException("KeyHelper", "Error initializing", e)
        }
        return null
    }

    @Provides
    fun provideKeyHelper(
        @ApplicationContext context: Context,
        sharedPreferences: SharedPreferences,
        keyStore: KeyStore?
    ): KeyHelper? {
        return if (keyStore == null) {
            null
        } else {
            getInstance(context, sharedPreferences, keyStore)
        }
    }

    @Provides
    @Singleton
    fun providesAuthenticationHandler(sharedPreferences: SharedPreferences): AuthenticationHandler {
        return if (BuildConfig.DEBUG && BuildConfig.TEST_USER_ID.isNotEmpty()) {
            AuthenticationHandler(BuildConfig.TEST_USER_ID)
        } else {
            AuthenticationHandler(sharedPreferences)
        }
    }

    @Provides
    fun providesResources(
        @ApplicationContext context: Context
    ): Resources {
        return context.resources
    }

    @Provides
    fun providesSoundFileLoader(
        @ApplicationContext context: Context
    ): SoundFileLoader {
        return SoundFileLoader(context)
    }

    @Provides
    @Singleton
    fun pushNotificationManager(
        apiClient: ApiClient,
        sharedPreferences: SharedPreferences,
        @ApplicationContext context: Context
    ): PushNotificationManager {
        return PushNotificationManager(apiClient, sharedPreferences, context)
    }

    @Provides
    @Singleton
    fun providesRemoteConfigManager(contentRepository: ContentRepository): AppConfigManager {
        return AppConfigManager(contentRepository)
    }

    @Provides
    fun providesReviewManager(
        @ApplicationContext context: Context,
        configManager: AppConfigManager
    ): ReviewManager {
        return ReviewManager(context, configManager)
    }
}
