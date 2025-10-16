//
//  ChallengeCategory.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 24.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol ChallengeCategoryProtocol {
    var id: String? { get set }
    var slug: String? { get set }
    var name: String? { get set }
}
