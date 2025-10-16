//
//  BaseModelProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 13.07.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol BaseModelProtocol {
    var isValid: Bool { get }
    var isManaged: Bool { get }
}
