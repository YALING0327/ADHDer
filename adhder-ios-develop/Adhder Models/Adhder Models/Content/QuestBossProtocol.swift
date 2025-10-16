//
//  File.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 12.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestBossProtocol {
    var name: String? { get set }
    var health: Int { get set }
    var rage: QuestBossRageProtocol? { get set }
    var strength: Float { get set }
    var defense: Float { get set }
}
