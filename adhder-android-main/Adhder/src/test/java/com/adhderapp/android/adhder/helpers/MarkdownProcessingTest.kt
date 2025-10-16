package com.adhderapp.android.adhder.helpers

import com.adhderapp.common.adhder.helpers.MarkdownParser.preprocessImageMarkdown
import com.adhderapp.common.adhder.helpers.MarkdownParser.preprocessMarkdownLinks
import com.adhderapp.common.adhder.helpers.MarkdownParser.processMarkdown
import io.kotest.core.spec.style.WordSpec
import io.kotest.matchers.shouldBe

class MarkdownProcessingTest : WordSpec({
    "processMarkdown" should {
        "replace image and link markdown correctly" {
            val input = "[Adhder Wiki](https://adhder.fandom.com/wiki/Adhder_Wiki) and ![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png\"Adhder Gold\")"
            val output = processMarkdown(input)
            output shouldBe "[Adhder Wiki](https://adhder.fandom.com/wiki/Adhder_Wiki) and ![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png \"Adhder Gold\")"
        }
    }

    "preprocessImageMarkdown" should {
        "add space before title in png image" {
            val input = "![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png\"Adhder Gold\")"
            val output = preprocessImageMarkdown(input)
            output shouldBe "![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png \"Adhder Gold\")"
        }

        "not modify non-image markdown" {
            val input = "[Adhder Wiki](https://adhder.fandom.com/wiki/Adhder_Wiki)"
            val output = preprocessImageMarkdown(input)
            output shouldBe "[Adhder Wiki](https://adhder.fandom.com/wiki/Adhder_Wiki)"
        }
    }

    "preprocessMarkdownLinks" should {
        "sanitize link url" {
            val input = "[Adhder Wiki](https://habi tica.fandom.com/wiki/Adhder_Wiki)"
            val output = preprocessMarkdownLinks(input)
            output shouldBe "[Adhder Wiki](https://adhder.fandom.com/wiki/Adhder_Wiki)"
        }

        "not modify non-link markdown" {
            val input = "![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png\"Adhder Gold\")"
            val output = preprocessMarkdownLinks(input)
            output shouldBe "![img](https://adhder-assets.s3.amazonaws.com/mobileApp/images/gold.png\"Adhder Gold\")"
        }
    }
})
