//
//  UITraitCollection-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 07.01.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import UIKit

extension UITraitCollection {
    var isIPadFullSize: Bool {
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
}
