//
//  BackerProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 11.08.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol BackerProtocol {
    var tier: Int { get set }
    var npc: String? { get set }
}
