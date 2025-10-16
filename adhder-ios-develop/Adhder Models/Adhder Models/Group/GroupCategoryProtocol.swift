//
//  GroupCategory.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 17.02.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol GroupCategoryProtocol: BaseModelProtocol {
    var id: String? { get set }
    var slug: String? { get set }
    var name: String? { get set }
}
