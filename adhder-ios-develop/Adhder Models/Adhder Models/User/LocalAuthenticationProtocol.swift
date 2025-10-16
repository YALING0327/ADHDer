//
//  LocalAuthenticationProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol LocalAuthenticationProtocol {
    var email: String? { get set }
    var username: String? { get set }
    var lowerCaseUsername: String? { get set }
    var hasPassword: Bool { get set }
}
