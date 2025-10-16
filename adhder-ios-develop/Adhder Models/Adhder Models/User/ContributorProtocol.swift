//
//  ContributorProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol ContributorProtocol {
    var level: Int { get set }
    var admin: Bool { get set }
    var text: String? { get set }
    var contributions: String? { get set }
}
