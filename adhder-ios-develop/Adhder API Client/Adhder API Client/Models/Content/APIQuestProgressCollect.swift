//
//  APIQuestProgressCollect.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 27.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIQuestProgressCollect: QuestProgressCollectProtocol, Decodable {
    var key: String?
    var count: Int
    
    init(key: String, count: Int) {
        self.key = key
        self.count = count
    }
}
