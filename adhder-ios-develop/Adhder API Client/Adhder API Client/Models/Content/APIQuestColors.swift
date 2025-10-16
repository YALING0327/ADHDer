//
//  APIQuestColors.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 22.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIQuestColors: QuestColorsProtocol, Decodable {
    var dark: String?
    var medium: String?
    var light: String?
    var extralight: String?
    
}
