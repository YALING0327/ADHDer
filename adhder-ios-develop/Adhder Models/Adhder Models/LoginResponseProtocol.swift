//
//  LoginResponseProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol LoginResponseProtocol {
    var id: String? { get set }
    var apiToken: String? { get set }
    var newUser: Bool { get set }
}
