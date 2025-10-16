package com.adhderapp.android.adhder.models.inventory

import android.content.Context
import com.adhderapp.android.adhder.R
import com.adhderapp.android.adhder.extensions.getTranslatedType
import io.kotest.core.spec.style.WordSpec
import io.kotest.matchers.shouldBe
import io.mockk.every
import io.mockk.mockk

private const val FAKE_STANDARD = "Standard"
private const val FAKE_PREMIUM = "premium"

class MountTest : WordSpec({
    val mount: Mount = Mount()
    lateinit var mockContext: Context
    beforeEach {
        mockContext = mockk()
    }
    "getTranslatedType" should {
        "return standard" {
            mount.type = "drop"
            every { mockContext.getString(R.string.standard) } returns FAKE_STANDARD

            val result = mount.getTranslatedType(mockContext)
            result shouldBe FAKE_STANDARD
        }

        "return premium without context" {
            mount.type = "premium"

            val result = mount.getTranslatedType(null)
            result shouldBe FAKE_PREMIUM
        }
    }
})
