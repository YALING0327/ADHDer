//
//  UIWindowScene-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 08.03.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import UIKit

extension UIWindowScene {
    var isLandscape: Bool {
        return interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight
    }
    
    var isPortrait: Bool {
        return interfaceOrientation == .portrait || interfaceOrientation == .portraitUpsideDown
    }
}
