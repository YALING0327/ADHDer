//
//  UserPartyProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 01.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol UserPartyProtocol {
    var id: String? { get set }
    var order: String? { get set }
    var orderAscending: Bool { get set }
    var quest: QuestStateProtocol? { get set }
    var seeking: Date? { get set }
}
