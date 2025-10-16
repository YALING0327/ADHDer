//
//  APIUserAchievements.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 23.06.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIUserAchievements: UserAchievementsProtocol, Decodable {
    
    var isValid: Bool = true
    var isManaged: Bool = false
    
    var quests: [AchievementProtocol]
    var challenges: [AchievementProtocol]
    var streak: Int = 0
    var createdTask: Bool = false
    var completedTask: Bool = false
    var hatchedPet: Bool = false
    var fedPet: Bool = false
    var purchasedEquipment: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case quests
        case challenges
        case streak
        case createdTask
        case completedTask
        case hatchedPet
        case fedPet
        case purchasedEquipment
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdTask = (try? values.decode(Bool.self, forKey: .createdTask)) ?? false
        completedTask = (try? values.decode(Bool.self, forKey: .completedTask)) ?? false
        hatchedPet = (try? values.decode(Bool.self, forKey: .hatchedPet)) ?? false
        fedPet = (try? values.decode(Bool.self, forKey: .fedPet)) ?? false
        purchasedEquipment = (try? values.decode(Bool.self, forKey: .purchasedEquipment)) ?? false
        streak = (try? values.decode(Int.self, forKey: .streak)) ?? 0
        quests = []
        challenges = []
        var combinedQuests = [String: Int]()
        if let userQuests = try? values.decode([String: Int].self, forKey: .quests), !userQuests.isEmpty {
            combinedQuests.merge(userQuests, uniquingKeysWith: { (first, _) in first })
        }
        if let stringCodedQuests = (try? values.decode([String: String].self, forKey: .quests))?.mapValues({ stringValue in
            return Int(stringValue) ?? 0
        }), !stringCodedQuests.isEmpty {
            combinedQuests.merge(stringCodedQuests, uniquingKeysWith: { (first, _) in first })
        }
        
        combinedQuests.forEach({ (key, count) in
            let achievement = APIAchievement()
            achievement.key = key
            achievement.earned = true
            achievement.optionalCount = count
            achievement.category = "quests"
            quests.append(achievement)
        })
        let userChallenges = try? values.decode([String].self, forKey: .challenges)
        userChallenges?.forEach({ key in
            let achievement = APIAchievement()
            achievement.key = key
            achievement.title = key
            achievement.earned = true
            achievement.category = "challenges"
            challenges.append(achievement)
        })
    }
}
