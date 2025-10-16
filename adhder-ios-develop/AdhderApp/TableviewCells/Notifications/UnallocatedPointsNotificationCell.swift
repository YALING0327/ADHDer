//
//  UnallocatedPointsNotificationCell.swift
//  Adhder
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class UnallocatedPointsNotificationCell: BaseNotificationCell<NotificationUnallocatedStatsProtocol> {
    
    override func configureFor(notification: NotificationUnallocatedStatsProtocol) {
        attributedTitle = try? AdhderMarkdownHelper.toAdhderAttributedString(L10n.Notifications.unallocatedStatPoints(notification.points))
        iconView.image = UIImage(asset: Asset.notificationsStats)
        super.configureFor(notification: notification)
        setNeedsLayout()
    }
}
