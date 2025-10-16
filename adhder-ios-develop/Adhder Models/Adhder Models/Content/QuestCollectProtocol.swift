//
//  QuestCollectProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 12.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol QuestCollectProtocol {
    var key: String? { get set }
    var text: String? { get set }
    var count: Int { get set }
}
