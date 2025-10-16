//
//  APITaskResponseDrop.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APITaskResponseDrop: TaskResponseDropProtocol, Decodable {
    var key: String?
    var type: String?
    var dialog: String?
}
