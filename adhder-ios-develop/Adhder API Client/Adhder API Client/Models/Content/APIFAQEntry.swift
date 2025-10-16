//
//  APIFAQEntry.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIFAQEntry: FAQEntryProtocol, Codable {
    var index: Int = 0
    var question: String?
    var ios: String?
    var web: String?
    
    enum CodingKeys: String, CodingKey {
        case question
        case ios
        case web
    }
}
