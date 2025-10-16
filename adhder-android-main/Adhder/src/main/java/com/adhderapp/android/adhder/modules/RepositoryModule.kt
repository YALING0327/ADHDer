package com.adhderapp.android.adhder.modules

import android.content.Context
import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.ContentRepository
import com.adhderapp.android.adhder.data.implementation.ContentRepositoryImpl
import com.adhderapp.android.adhder.data.local.ContentLocalRepository
import com.adhderapp.android.adhder.data.local.implementation.RealmContentLocalRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import io.realm.Realm

@InstallIn(SingletonComponent::class)
@Module
open class RepositoryModule {
    @Provides
    open fun providesRealm(): Realm {
        return Realm.getDefaultInstance()
    }

    @Provides
    fun providesContentLocalRepository(realm: Realm): ContentLocalRepository {
        return RealmContentLocalRepository(realm)
    }

    @Provides
    fun providesContentRepository(
        contentLocalRepository: ContentLocalRepository,
        apiClient: ApiClient,
        @ApplicationContext context: Context,
        authenticationHandler: AuthenticationHandler
    ): ContentRepository {
        return ContentRepositoryImpl(
            contentLocalRepository,
            apiClient,
            context,
            authenticationHandler
        )
    }
}
