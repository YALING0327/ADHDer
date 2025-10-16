//
//  APIVerifyUsernameResponse.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 09.10.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class APIVerifyUsernameResponse: Decodable, VerifyUsernameResponse {
    public var isUsable: Bool = false
    public var issues: [String]? = []
}
