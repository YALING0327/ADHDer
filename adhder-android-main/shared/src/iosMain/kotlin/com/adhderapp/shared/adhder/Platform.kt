package com.adhderapp.shared.adhder

import platform.UIKit.UIDevice

actual class Platform actual constructor() {
    actual val platform: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
}

actual interface HParcelable
