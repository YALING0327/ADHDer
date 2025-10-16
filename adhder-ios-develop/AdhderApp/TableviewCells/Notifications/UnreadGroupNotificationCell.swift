//
//  UnreadGroupNotification.swift
//  Adhder
//
//  Created by Phillip Thelen on 02.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class UnreadGroupNotificationCell: BaseNotificationCell<NotificationNewChatProtocol> {
    
    func configureFor(notification: NotificationNewChatProtocol, partyID: String?) {
        super.configureFor(notification: notification)
        if notification.groupID == partyID {
            attributedTitle = try? AdhderMarkdownHelper.toAdhderAttributedString(L10n.Notifications.unreadPartyMessage(notification.groupName?.unicodeEmoji ?? ""))
        } else {
            attributedTitle = try? AdhderMarkdownHelper.toAdhderAttributedString(L10n.Notifications.unreadGuildMessage(notification.groupName?.unicodeEmoji ?? ""))
        }
    }
}
