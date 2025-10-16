//
//  ChatMessageLikeProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol ChatMessageReactionProtocol {
    var userID: String? { get set }
    var hasReacted: Bool { get set }
}
