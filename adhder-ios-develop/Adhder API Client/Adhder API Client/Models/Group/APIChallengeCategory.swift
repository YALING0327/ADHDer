//
//  APIChallengeCategory.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 24.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIChallengeCategory: ChallengeCategoryProtocol, Decodable {
    var id: String?
    var slug: String?
    var name: String?
}
