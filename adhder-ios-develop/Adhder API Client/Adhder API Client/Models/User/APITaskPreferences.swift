//
//  APITaskPreferences.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.08.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APITaskPreferences: TaskPreferencesProtocol, Decodable {
    var confirmScoreNotes: Bool = false
    var groupByChallenge: Bool = false
    var mirrorGroupTasks: [String]?
}
