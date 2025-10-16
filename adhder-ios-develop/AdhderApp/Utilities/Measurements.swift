//
//  Measurements.swift
//  Adhder
//
//  Created by Phillip Thelen on 15.09.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import Foundation
import QuartzCore

class Measurements {
    private static var starts = [String: CFTimeInterval]()
    
    static func start(identifier: String) {
        starts[identifier] = CACurrentMediaTime()
    }
    
    static func stop(identifier: String) {
        guard let time = starts[identifier] else {
            return
        }
        let elapsed = CACurrentMediaTime() - time
        print("Time for \(identifier): \(elapsed)ms")
    }
}
