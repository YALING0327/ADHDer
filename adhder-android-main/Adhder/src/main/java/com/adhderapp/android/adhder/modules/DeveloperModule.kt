package com.adhderapp.android.adhder.modules

import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

// provide proxy class for libraries(to avoid 65k limit)
@InstallIn(SingletonComponent::class)
@Module
open class DeveloperModule
