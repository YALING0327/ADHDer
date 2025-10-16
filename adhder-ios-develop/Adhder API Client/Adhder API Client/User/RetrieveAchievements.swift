//
//  RetrieveAchievements.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 11.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveAchievementsCall: ResponseObjectCall<AchievementListProtocol, APIAchievementList> {
    public init(userID: String) {
        super.init(httpMethod: .GET, endpoint: "members/\(userID)/achievements")
    }
}
