//
//  ReadNotificationsCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 03.07.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class ReadNotificationsCall: ResponseArrayCall<NotificationProtocol, APINotification> {
    public init(notificationIDs: [String]) {
        let obj = ["notificationIds": notificationIDs]
        let json = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        super.init(httpMethod: .POST, endpoint: "notifications/read", postData: json)
    }
}
