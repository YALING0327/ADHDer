//
//  NotificationFirstDropProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 25.06.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol NotificationFirstDropProtocol: NotificationProtocol {
    var egg: String? { get set }
    var hatchingPotion: String? { get set }
}
