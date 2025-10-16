package com.adhderapp.android.adhder.ui.viewmodels

import androidx.compose.runtime.mutableStateOf
import com.adhderapp.android.adhder.data.UserRepository
import com.adhderapp.shared.adhder.models.tasks.Attribute
import com.adhderapp.shared.adhder.models.tasks.HabitResetOption
import com.adhderapp.shared.adhder.models.tasks.TaskDifficulty
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class TaskFormViewModel
@Inject
constructor(
    userRepository: UserRepository,
    userViewModel: MainUserViewModel
) : BaseViewModel(userRepository, userViewModel) {
    val taskDifficulty = mutableStateOf(TaskDifficulty.EASY)
    val selectedAttribute = mutableStateOf(Attribute.STRENGTH)
    val habitResetOption = mutableStateOf(HabitResetOption.DAILY)
    val habitScoringPositive = mutableStateOf(true)
    val habitScoringNegative = mutableStateOf(false)
}
