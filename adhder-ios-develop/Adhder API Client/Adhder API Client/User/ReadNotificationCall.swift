//
//  ReadNotificationCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 03.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class ReadNotificationCall: ResponseArrayCall<NotificationProtocol, APINotification> {
    public init(notificationID: String) {
        super.init(httpMethod: .POST, endpoint: "notifications/\(notificationID)/read", postData: nil)
    }
}
