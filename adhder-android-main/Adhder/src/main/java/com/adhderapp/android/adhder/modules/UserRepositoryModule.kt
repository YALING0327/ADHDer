package com.adhderapp.android.adhder.modules

import android.content.Context
import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.ChallengeRepository
import com.adhderapp.android.adhder.data.CustomizationRepository
import com.adhderapp.android.adhder.data.FAQRepository
import com.adhderapp.android.adhder.data.InventoryRepository
import com.adhderapp.android.adhder.data.SetupCustomizationRepository
import com.adhderapp.android.adhder.data.SocialRepository
import com.adhderapp.android.adhder.data.TagRepository
import com.adhderapp.android.adhder.data.TaskRepository
import com.adhderapp.android.adhder.data.TutorialRepository
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.android.adhder.data.implementation.ChallengeRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.CustomizationRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.FAQRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.InventoryRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.SetupCustomizationRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.SocialRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.TagRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.TaskRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.TutorialRepositoryImpl
import com.adhderapp.android.adhder.data.implementation.UserRepositoryImpl
import com.adhderapp.android.adhder.data.local.ChallengeLocalRepository
import com.adhderapp.android.adhder.data.local.CustomizationLocalRepository
import com.adhderapp.android.adhder.data.local.FAQLocalRepository
import com.adhderapp.android.adhder.data.local.InventoryLocalRepository
import com.adhderapp.android.adhder.data.local.SocialLocalRepository
import com.adhderapp.android.adhder.data.local.TagLocalRepository
import com.adhderapp.android.adhder.data.local.TaskLocalRepository
import com.adhderapp.android.adhder.data.local.TutorialLocalRepository
import com.adhderapp.android.adhder.data.local.UserLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmChallengeLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmCustomizationLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmFAQLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmInventoryLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmSocialLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmTagLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmTaskLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmTutorialLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmUserLocalRepository
import com.adhderapp.android.adhder.helpers.AppConfigManager
import com.adhderapp.android.adhder.helpers.PurchaseHandler
import com.adhderapp.android.adhder.ui.viewmodels.MainUserViewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import io.realm.Realm
import javax.inject.Singleton

@InstallIn(SingletonComponent::class)
@Module
class UserRepositoryModule {
    @Provides
    fun providesSetupCustomizationRepository(
        @ApplicationContext context: Context
    ): SetupCustomizationRepository {
        return SetupCustomizationRepositoryImpl(context)
    }

    @Provides
    fun providesTaskLocalRepository(realm: Realm): TaskLocalRepository {
        return RealmTaskLocalRepository(realm)
    }

    @Provides
    fun providesTaskRepository(
        localRepository: TaskLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler,
        appConfigManager: AppConfigManager
    ): TaskRepository {
        return TaskRepositoryImpl(
            localRepository,
            apiClient,
            authenticationHandler,
            appConfigManager
        )
    }

    @Provides
    fun providesTagLocalRepository(realm: Realm): TagLocalRepository {
        return RealmTagLocalRepository(realm)
    }

    @Provides
    fun providesTagRepository(
        localRepository: TagLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): TagRepository {
        return TagRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    fun provideChallengeLocalRepository(realm: Realm): ChallengeLocalRepository {
        return RealmChallengeLocalRepository(realm)
    }

    @Provides
    fun providesChallengeRepository(
        localRepository: ChallengeLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): ChallengeRepository {
        return ChallengeRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    fun providesUserLocalRepository(realm: Realm): UserLocalRepository {
        return RealmUserLocalRepository(realm)
    }

    @Provides
    fun providesUserRepository(
        localRepository: UserLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler,
        taskRepository: TaskRepository,
        appConfigManager: AppConfigManager
    ): UserRepository {
        return UserRepositoryImpl(
            localRepository,
            apiClient,
            authenticationHandler,
            taskRepository,
            appConfigManager
        )
    }

    @Provides
    fun providesSocialLocalRepository(realm: Realm): SocialLocalRepository {
        return RealmSocialLocalRepository(realm)
    }

    @Provides
    fun providesSocialRepository(
        localRepository: SocialLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): SocialRepository {
        return SocialRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    fun providesInventoryLocalRepository(
        realm: Realm
    ): InventoryLocalRepository {
        return RealmInventoryLocalRepository(realm)
    }

    @Provides
    fun providesInventoryRepository(
        localRepository: InventoryLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler,
        remoteConfig: AppConfigManager
    ): InventoryRepository {
        return InventoryRepositoryImpl(
            localRepository,
            apiClient,
            authenticationHandler,
            remoteConfig
        )
    }

    @Provides
    fun providesFAQLocalRepository(realm: Realm): FAQLocalRepository {
        return RealmFAQLocalRepository(realm)
    }

    @Provides
    fun providesFAQRepository(
        localRepository: FAQLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): FAQRepository {
        return FAQRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    fun providesTutorialLocalRepository(realm: Realm): TutorialLocalRepository {
        return RealmTutorialLocalRepository(realm)
    }

    @Provides
    fun providesTutorialRepository(
        localRepository: TutorialLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): TutorialRepository {
        return TutorialRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    fun providesCustomizationLocalRepository(realm: Realm): CustomizationLocalRepository {
        return RealmCustomizationLocalRepository(realm)
    }

    @Provides
    fun providesCustomizationRepository(
        localRepository: CustomizationLocalRepository,
        apiClient: ApiClient,
        authenticationHandler: AuthenticationHandler
    ): CustomizationRepository {
        return CustomizationRepositoryImpl(localRepository, apiClient, authenticationHandler)
    }

    @Provides
    @Singleton
    fun providesPurchaseHandler(
        @ApplicationContext context: Context,
        apiClient: ApiClient,
        userViewModel: MainUserViewModel,
        appConfigManager: AppConfigManager
    ): PurchaseHandler {
        return PurchaseHandler(context, apiClient, userViewModel, appConfigManager)
    }
}
