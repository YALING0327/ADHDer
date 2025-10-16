//
//  APISubscriptionPlan.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 23.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APISubscriptionPlan: SubscriptionPlanProtocol, Decodable {
    var quantity: Int
    var gemsBought: Int
    var perkMonthCount: Int
    var dateTerminated: Date?
    var dateUpdated: Date?
    var dateCreated: Date?
    var dateCurrentTypeCreated: Date?
    var planId: String?
    var customerId: String?
    var paymentMethod: String?
    var consecutive: SubscriptionConsecutiveProtocol?
    var mysteryItems: [String]
    var hourglassPromoReceived: Date?
    var extraMonths: Int
    
    enum CodingKeys: String, CodingKey {
        case quantity
        case dateTerminated
        case dateUpdated
        case dateCreated
        case dateCurrentTypeCreated
        case gemsBought
        case perkMonthCount
        case planId
        case customerId
        case paymentMethod
        case consecutive
        case mysteryItems
        case hourglassPromoReceived
        case extraMonths
    }
    
    var isValid: Bool {
        return true
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quantity = (try? values.decode(Int.self, forKey: .quantity)) ?? 0
        gemsBought = (try? values.decode(Int.self, forKey: .gemsBought)) ?? 0
        perkMonthCount = (try? values.decode(Int.self, forKey: .perkMonthCount)) ?? 0
        dateTerminated = try? values.decode(Date.self, forKey: .dateTerminated)
        dateUpdated = try? values.decode(Date.self, forKey: .dateUpdated)
        dateCreated = try? values.decode(Date.self, forKey: .dateCreated)
        dateCurrentTypeCreated = try? values.decode(Date.self, forKey: .dateCurrentTypeCreated)
        planId = try? values.decode(String.self, forKey: .planId)
        customerId = try? values.decode(String.self, forKey: .customerId)
        paymentMethod = try? values.decode(String.self, forKey: .paymentMethod)
        consecutive = try? values.decode(APISubscriptionConsecutive.self, forKey: .consecutive)
        mysteryItems = (try? values.decode([String].self, forKey: .mysteryItems)) ?? []
        hourglassPromoReceived = (try? values.decode(Date.self, forKey: .hourglassPromoReceived))
        extraMonths = (try? values.decode(Int.self, forKey: .extraMonths)) ?? 0
    }
}
