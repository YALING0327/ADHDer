//
//  TaskResponseDropProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol TaskResponseDropProtocol {
    var key: String? { get set }
    var type: String? { get set }
    var dialog: String? { get set }
}
