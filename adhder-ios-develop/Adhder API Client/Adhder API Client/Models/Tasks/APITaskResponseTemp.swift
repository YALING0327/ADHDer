//
//  APITaskResponseTemp.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APITaskResponseTemp: TaskResponseTempProtocol, Decodable {
    var quest: TaskResponseQuestProtocol?
    var drop: TaskResponseDropProtocol?
    
    enum CodingKeys: String, CodingKey {
        case quest
        case drop
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quest = try? values.decode(APITaskResponseQuest.self, forKey: .quest)
        drop = try? values.decode(APITaskResponseDrop.self, forKey: .drop)
    }
}
