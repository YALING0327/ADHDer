//
//  AchievementNotificationCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 11.01.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class AchievementNotificationCell: BaseNotificationCell<NotificationProtocol> {
    
    override func configureFor(notification: NotificationProtocol) {
        title = notification.achievementModalText
        iconView.image = UIImage(asset: Asset.notificationsStats)
        super.configureFor(notification: notification)
        setNeedsLayout()
    }
}
