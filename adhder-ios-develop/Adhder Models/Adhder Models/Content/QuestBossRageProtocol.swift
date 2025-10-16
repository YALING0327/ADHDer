//
//  QuestBossRageProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 18.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestBossRageProtocol {
    var title: String? { get set }
    var rageDescription: String? { get set }
    var value: Int { get set }
}
