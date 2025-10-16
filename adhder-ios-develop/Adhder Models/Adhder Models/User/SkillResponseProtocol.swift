//
//  SkillResponseProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 29.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol SkillResponseProtocol {
    var user: UserProtocol? { get set }
    var task: TaskProtocol? { get set }
}
