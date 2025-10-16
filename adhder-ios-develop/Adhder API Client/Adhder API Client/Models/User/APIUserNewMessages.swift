//
//  File.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIUserNewMessages: UserNewMessagesProtocol, Decodable {
    
    var id: String?
    var name: String?
    var hasNewMessages: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case hasNewMessages = "value"
    }
}
