//
//  DateEncodingStrategy-Extension.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 01.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

extension JSONEncoder {
    
    func setAdhderDateEncodingStrategy() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateEncodingStrategy = .formatted(dateFormatter)
    }
}
