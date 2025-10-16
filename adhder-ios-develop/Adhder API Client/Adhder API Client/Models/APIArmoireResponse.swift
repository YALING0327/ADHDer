//
//  APIArmoireResponse.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 04.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIArmoireResponse: ArmoireResponseProtocol, Decodable {
    var type: String?
    var dropKey: String?
    var dropArticle: String?
    var dropText: String?
    var value: Float?
}
