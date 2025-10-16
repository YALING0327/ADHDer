//
//  APIProfile.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIProfile: ProfileProtocol, Codable {
    var photoUrl: String?
    var name: String?
    var blurb: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case blurb
        case photoUrl = "imageUrl"
    }
}
