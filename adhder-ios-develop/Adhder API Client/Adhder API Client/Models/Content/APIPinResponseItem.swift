//
//  APIPinResponseItem.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 17.07.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class APIPinResponseItem: PinResponseItemProtocol, Decodable {
    public var type: String = ""
    public var path: String = ""
}
