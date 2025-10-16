//
//  AvatarProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol AvatarProtocol: BaseModelProtocol {
    var items: UserItemsProtocol? { get set }
    var preferences: PreferencesProtocol? { get set }
    var stats: StatsProtocol? { get set }
}
