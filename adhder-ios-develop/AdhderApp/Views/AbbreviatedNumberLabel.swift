//
//  AbbreviatedNumberLabel.swift
//  Adhder
//
//  Created by Phillip Thelen on 18.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import UIKit

class AbbreviatedNumberLabel: UILabel {
    override var text: String? {
        get { super.text }
        set {
            super.text = newValue?.stringWithAbbreviatedNumber()
        }
    }
}
