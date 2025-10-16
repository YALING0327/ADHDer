//
//  Quest-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 24.01.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

extension QuestProtocol {
    
    var uicolorDark: UIColor {
        return UIColor.init(colors?.dark ?? "", defaultColor: UIColor.clear)
    }
    
    var uicolorMedium: UIColor {
        return UIColor.init(colors?.medium ?? "", defaultColor: UIColor.clear)
    }
    
    var uicolorLight: UIColor {
        return UIColor.init(colors?.light ?? "", defaultColor: UIColor.clear)
    }
    
    var uicolorExtraLight: UIColor {
        return UIColor.init(colors?.extralight ?? "", defaultColor: UIColor.clear)
    }
}
