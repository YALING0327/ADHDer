//
//  APIBaseNotification.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 02.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

private class APINotificationAchievementData: Decodable {
    var achievement: String
    var message: String?
    var modalText: String?
}

private class APIItemReceivedData: Decodable {
    var title: String
    var icon: String
    var destination: String
    var text: String
}

public class APINotification: NotificationProtocol, NotificationNewsProtocol, NotificationNewChatProtocol,
                              NotificationUnallocatedStatsProtocol, NotificationFirstDropProtocol, NotificationLoginIncentiveProtocol, NotificationItemReceivedProtocol, Decodable {
    public var isValid: Bool = true
    public var isManaged: Bool = false
    
    public var id: String = ""
    public var type: AdhderNotificationType = .generic
    public var seen: Bool = false
    public var groupID: String?
    public var groupName: String?
    public var isParty: Bool = false
    public var title: String?
    public var points: Int = 0
    public var achievementKey: String?
    public var achievementMessage: String?
    public var achievementModalText: String?
    public var egg: String?
    public var hatchingPotion: String?
    public var nextRewardAt: Int = 0
    public var message: String?
    public var rewardKey: [String] = []
    public var rewardText: String?
    
    public var icon: String?
    public var openDestination: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case data
        case seen
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        type = AdhderNotificationType(rawValue: (try? values.decode(String.self, forKey: .type)) ?? "") ?? .generic
        seen = (try? values.decode(Bool.self, forKey: .seen)) ?? false
        switch type {
        case .newChatMessage:
            let data = try? values.decode(APINotificationNewChatData.self, forKey: .data)
            groupID = data?.groupID
            groupName = data?.groupName
        case .newStuff:
            let data = try? values.decode(APINotificationNewStuffData.self, forKey: .data)
            title = data?.title
        case .unallocatedStatsPoints:
            let data = try? values.decode(APINotificationUnallocatedStatsData.self, forKey: .data)
            points = data?.points ?? 0
        case .firstDrop:
            let data = try? values.decode(APINotificationFirstDropData.self, forKey: .data)
            egg = data?.egg
            hatchingPotion = data?.hatchingPotion
        case .loginIncentive:
            let data = try? values.decode(APILoginIncentiveData.self, forKey: .data)
            nextRewardAt = data?.nextRewardAt ?? 0
            message = data?.message
            rewardKey = data?.rewardKey ?? []
            rewardText = data?.rewardText
        case .itemReceived:
            let data = try? values.decode(APIItemReceivedData.self, forKey: .data)
            title = data?.title
            message = data?.text
            icon = data?.icon
            openDestination = data?.destination
        default:
            break
        }
        
        if type.rawValue.contains("ACHIEVEMENT") || type == .loginIncentive {
            let data = try? values.decode(APINotificationAchievementData.self, forKey: .data)
            achievementKey = data?.achievement
            achievementMessage = data?.message
            achievementModalText = data?.modalText
        }
    }
}
