//
//  AdhderNotificationNewsProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationNewsProtocol: NotificationProtocol {
    var title: String? { get set }
}
