//
//  TestPreferences.swift
//  Adhder ModelsTests
//
//  Created by Phillip Thelen on 28.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
@testable import Adhder_Models

class TestPreferences: PreferencesProtocol {
    var dateFormat: String?
    
    var tasks: (any Adhder_Models.TaskPreferencesProtocol)?
    
    var autoEquip: Bool = true
    
    var pushNotifications: PushNotificationsProtocol?
    
    var emailNotifications: EmailNotificationsProtocol?
    
    var hair: HairProtocol?
    
    var searchableUsername: Bool  = true
    
    var isValid: Bool =  true
    
    var isManaged: Bool = false
    
    var skin: String?
    var language: String?
    var automaticAllocation: Bool = false
    var dayStart: Int = 0
    var allocationMode: String?
    var background: String?
    var useCostume: Bool = false
    var dailyDueDefaultView: Bool = false
    var shirt: String?
    var size: String?
    var disableClasses: Bool = false
    var chair: String?
    var sleep: Bool = false
    var timezoneOffset: Int = 0
    var sound: String?
}
