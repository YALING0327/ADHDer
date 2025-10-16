//
//  QuestDropProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 18.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestDropProtocol {
    var gold: Int { get set }
    var experience: Int { get set }
    var unlock: String? { get set }
    var items: [QuestDropItemProtocol] { get set }
}
