//
//  WeekRepeatProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 26.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol WeekRepeatProtocol {
    var monday: Bool { get set }
    var tuesday: Bool { get set }
    var wednesday: Bool { get set }
    var thursday: Bool { get set }
    var friday: Bool { get set }
    var saturday: Bool { get set }
    var sunday: Bool { get set }
}
