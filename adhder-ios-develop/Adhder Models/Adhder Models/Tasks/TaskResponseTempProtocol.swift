//
//  TaskResponseTempProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 29.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol TaskResponseTempProtocol {
    var quest: TaskResponseQuestProtocol? { get set }
    var drop: TaskResponseDropProtocol? { get set }
}
