//
//  NSRange-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 15.01.25.
//  Copyright © 2025 AdhderApp Inc. All rights reserved.
//

import Foundation

extension NSRange {
    func isSafe(for str: NSString) -> Bool {
        return location != NSNotFound && location + length <= str.length
    }
    
    func isSafe(for str: NSAttributedString) -> Bool {
        return location != NSNotFound && location + length <= str.length
    }
}
