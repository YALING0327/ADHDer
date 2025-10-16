//
//  UIStackview-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 13.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in view.removeFromSuperview() }
    }
}
