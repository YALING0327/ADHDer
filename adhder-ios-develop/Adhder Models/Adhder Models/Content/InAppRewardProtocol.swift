//
//  InAppRewardProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 16.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol InAppRewardProtocol: BaseRewardProtocol {
    var key: String? { get set }
    var eventStart: Date? { get set }
    var eventEnd: Date? { get set }
    var endDate: Date? { get set }
    var currency: String? { get set }
    var isSuggested: Bool { get set }
    var lastPurchased: Date? { get set }
    var locked: Bool { get set }
    var path: String? { get set }
    var pinType: String? { get set }
    var purchaseType: String? { get set }
    var imageName: String? { get set }
    var isSubscriberItem: Bool { get set }
    var unlockConditionReason: String? { get set }
    var unlockConditionText: String? { get set }
    var unlockConditionIncentiveThreshold: Int { get set }
    var previous: String? { get set }
    var level: Int { get set }
    
    var category: ShopCategoryProtocol? { get }

}

public extension InAppRewardProtocol {
    func availableUntil() -> Date? {
        return endDate ?? eventEnd
    }
    
    var iconName: String {
        if purchaseType == "customization" && imageName?.starts(with: "icon_") == false {
            return "icon_\(imageName ?? "")"
        } else {
            return imageName ?? ""
        }
    }
}
