//
//  APIUserStyle.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIUserStyle: UserStyleProtocol, Decodable {
    var items: UserItemsProtocol?
    var preferences: PreferencesProtocol?
    var stats: StatsProtocol?
    public var isValid: Bool { return true }
    public var isManaged: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case stats
        case preferences
        case items
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stats = (try? values.decode(APIStats.self, forKey: .stats))
        preferences = (try? values.decode(APIPreferences.self, forKey: .preferences))
        items = (try? values.decode(APIUserItems.self, forKey: .items))
    }
}
