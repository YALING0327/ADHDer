//
//  APISubscriptionConsecutive.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 23.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APISubscriptionConsecutive: SubscriptionConsecutiveProtocol, Decodable {
    var hourglasses: Int = 0
    var gemCapExtra: Int = 0
    var count: Int = 0
    var offset: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case hourglasses = "trinkets"
        case gemCapExtra
        case count
        case offset
    }
}
