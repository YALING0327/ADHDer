//
//  APISocialAuthentication.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 23.11.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APISocialAuthentication: SocialAuthenticationProtocol, Decodable {
    var emails: [String] = []
    var id: String?
}
