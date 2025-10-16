//
//  AdhderAnalytics.swift
//  Shared
//
//  Created by Phillip Thelen on 25.09.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation
import Amplitude_iOS

public class AdhderAnalytics {
    public static let shared = AdhderAnalytics()
    
    public func setUserID(_ userID: String?) {
        Amplitude.instance().setUserId(userID)
    }
    
    public func logNavigationEvent(_ pageName: String) {
        let properties = [
            "eventAction": "navigate",
            "eventCategory": "navigation",
            "hitType": "pageview",
            "page": pageName,
        ]
        Amplitude.instance()?.logEvent("navigate", withEventProperties: properties)
    }
    
    public func log(_ eventName: String, withEventProperties properties: [AnyHashable: Any]) {
        Amplitude.instance()?.logEvent(eventName, withEventProperties: properties)
    }
}
