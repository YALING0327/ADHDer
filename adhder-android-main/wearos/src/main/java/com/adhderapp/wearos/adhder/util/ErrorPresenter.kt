package com.adhderapp.wearos.adhder.util

import androidx.lifecycle.MutableLiveData
import com.adhderapp.wearos.adhder.models.DisplayedError

interface ErrorPresenter {
    val errorValues: MutableLiveData<DisplayedError>
}
