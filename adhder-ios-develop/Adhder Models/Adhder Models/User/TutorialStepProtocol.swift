//
//  TutorialStepProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 30.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol TutorialStepProtocol {
    var key: String? { get set }
    var type: String? { get set }
    var wasSeen: Bool { get set }
}
