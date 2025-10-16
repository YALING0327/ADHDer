package com.adhderapp.android.adhder.data.local.implementation

import com.adhderapp.android.adhder.data.local.TagLocalRepository
import com.adhderapp.android.adhder.models.Tag
import io.realm.Realm
import io.realm.kotlin.toFlow
import kotlinx.coroutines.flow.Flow

class RealmTagLocalRepository(realm: Realm) : RealmBaseLocalRepository(realm), TagLocalRepository {
    override fun deleteTag(tagID: String) {
        val tags = realm.where(Tag::class.java).equalTo("id", tagID).findAll()
        executeTransaction { tags.deleteAllFromRealm() }
    }

    override fun getTags(userId: String): Flow<List<Tag>> {
        return realm.where(Tag::class.java).equalTo("userId", userId).findAll().toFlow()
    }
}
