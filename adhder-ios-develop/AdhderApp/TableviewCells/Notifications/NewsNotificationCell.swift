//
//  NewsNotificationCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class NewsNotificationCell: BaseNotificationCell<NotificationNewsProtocol> {
    
    override func configureFor(notification: NotificationNewsProtocol) {
        super.configureFor(notification: notification)
        title = L10n.Notifications.newBailey
        itemDescription = notification.title
        iconView.image = UIImage(asset: Asset.notificationsBailey)
        super.configureFor(notification: notification)
        setNeedsLayout()
    }
}
