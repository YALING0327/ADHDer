//
//  APIPushDevice.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 28.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

class APIPushDevice: PushDeviceProtocol, Decodable {
    var type: String?
    var regId: String?
}
