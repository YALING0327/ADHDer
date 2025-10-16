//
//  APICustomizationSet.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 20.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APICustomizationSet: CustomizationSetProtocol, Decodable {
    var setItems: [CustomizationProtocol]? {
        return nil
    }
    
    var key: String?
    var text: String?
    var availableFrom: Date?
    var availableUntil: Date?
    var setPrice: Float = 0
}
