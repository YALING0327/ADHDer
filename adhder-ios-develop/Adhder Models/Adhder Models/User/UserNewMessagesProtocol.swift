//
//  UserNewMessagesProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 13.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol UserNewMessagesProtocol {
    var id: String? { get set }
    var name: String? { get set }
    var hasNewMessages: Bool { get set }
}
