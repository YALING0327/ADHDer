//
//  APIQuestBossRage.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIQuestBossRage: QuestBossRageProtocol, Decodable {
    var title: String?
    var rageDescription: String?
    var value: Int = 0
}
