//
//  OwnedCustomizationProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 23.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol OwnedCustomizationProtocol {
    var key: String? { get set }
    var type: String? { get set }
    var group: String? { get set }
    var isOwned: Bool { get set }
}
