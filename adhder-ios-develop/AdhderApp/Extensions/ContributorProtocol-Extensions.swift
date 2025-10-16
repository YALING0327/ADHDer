//
//  ContributorProtocol-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

extension ContributorProtocol {
    
    var color: UIColor {
        return UIColor.contributorColor(forTier: level)
    }
    
}
