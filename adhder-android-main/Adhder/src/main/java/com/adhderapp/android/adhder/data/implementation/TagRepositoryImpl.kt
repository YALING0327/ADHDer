@file:OptIn(ExperimentalCoroutinesApi::class)

package com.adhderapp.android.adhder.data.implementation

import com.adhderapp.android.adhder.data.ApiClient
import com.adhderapp.android.adhder.data.TagRepository
import com.adhderapp.android.adhder.data.local.TagLocalRepository
import com.adhderapp.android.adhder.models.Tag
import com.adhderapp.android.adhder.modules.AuthenticationHandler
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flatMapLatest

class TagRepositoryImpl(
    localRepository: TagLocalRepository,
    apiClient: ApiClient,
    authenticationHandler: AuthenticationHandler
) : BaseRepositoryImpl<TagLocalRepository>(localRepository, apiClient, authenticationHandler),
    TagRepository {
    override fun getTags() = authenticationHandler.userIDFlow.flatMapLatest { getTags(it) }

    override fun getTags(userId: String): Flow<List<Tag>> {
        return localRepository.getTags(userId)
    }

    override suspend fun createTag(tag: Tag): Tag? {
        val savedTag = apiClient.createTag(tag) ?: return null
        savedTag.userId = currentUserID
        localRepository.save(savedTag)
        return savedTag
    }

    override suspend fun updateTag(tag: Tag): Tag? {
        val savedTag = apiClient.updateTag(tag.id, tag) ?: return null
        savedTag.userId = currentUserID
        localRepository.save(savedTag)
        return savedTag
    }

    override suspend fun deleteTag(id: String): Void? {
        apiClient.deleteTag(id)
        localRepository.deleteTag(id)
        return null
    }

    override suspend fun createTags(tags: Collection<Tag>): List<Tag> {
        return tags.mapNotNull {
            createTag(it)
        }
    }

    override suspend fun updateTags(tags: Collection<Tag>): List<Tag> {
        return tags.mapNotNull {
            updateTag(it)
        }
    }

    override suspend fun deleteTags(tagIds: Collection<String>): List<Void> {
        return tagIds.mapNotNull {
            deleteTag(it)
        }
    }
}
