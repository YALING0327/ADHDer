//
//  VerifyUsernameResponse.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 09.10.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol CheckEmailResponse {
    var email: String? { get set }
    var valid: Bool { get set }
    var error: String? { get set }
}
