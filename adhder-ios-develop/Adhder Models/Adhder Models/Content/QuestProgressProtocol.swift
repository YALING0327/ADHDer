//
//  QuestProgressProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 13.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestProgressProtocol {
    var health: Float { get set }
    var rage: Float { get set }
    var up: Float { get set }
    var collectedItems: Int { get set }
    var collect: [QuestProgressCollectProtocol] { get set }
}
