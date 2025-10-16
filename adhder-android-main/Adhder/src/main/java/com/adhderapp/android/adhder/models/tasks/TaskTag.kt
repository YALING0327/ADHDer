package com.adhderapp.android.adhder.models.tasks

import com.adhderapp.android.adhder.models.BaseObject
import com.adhderapp.android.adhder.models.Tag
import io.realm.RealmObject
import io.realm.annotations.RealmClass

@RealmClass(embedded = true)
open class TaskTag : RealmObject(), BaseObject {
    var tag: Tag? = null
    var task: Task? = null
}
