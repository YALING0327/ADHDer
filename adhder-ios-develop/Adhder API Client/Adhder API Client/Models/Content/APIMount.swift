//
//  APIMount.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIMount: MountProtocol, Decodable {
    var key: String?
    var egg: String?
    var potion: String?
    var type: String?
    var text: String?
    var isValid: Bool = true
    var isManaged: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case key
        case egg
        case potion
        case type
        case text
    }
}
