//
//  APITaskResponseQuest.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APITaskResponseQuest: TaskResponseQuestProtocol, Decodable {
    var progressDelta: Float = 0
    var collection: Int?
    
    enum CodingKeys: String, CodingKey {
        case progressDelta
        case collection
    }
}
