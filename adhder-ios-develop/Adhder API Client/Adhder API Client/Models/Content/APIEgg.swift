//
//  APIEgg.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 12.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIEgg: EggProtocol, Decodable {
    var isSubscriberItem: Bool = false
    var key: String?
    var text: String?
    var mountText: String?
    var notes: String?
    var value: Float = 0
    var adjective: String?
    var itemType: String?
    var eventStart: Date?
    var eventEnd: Date?
    var isValid: Bool = true
    public var isManaged: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case key
        case text
        case mountText
        case notes
        case value
        case adjective
        case itemType
        case event
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try? values.decode(String.self, forKey: .key)
        text = try? values.decode(String.self, forKey: .text)
        mountText = try? values.decode(String.self, forKey: .mountText)
        notes = try? values.decode(String.self, forKey: .notes)
        value = (try? values.decode(Float.self, forKey: .value)) ?? 0
        adjective = try? values.decode(String.self, forKey: .adjective)
        itemType = try? values.decode(String.self, forKey: .itemType)
        let event = try? values.decode(APIEvent.self, forKey: .event)
        eventStart = event?.start
        eventEnd = event?.end
    }
}
