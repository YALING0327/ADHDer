//
//  ShopProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol ShopProtocol {
    var identifier: String? { get set }
    var text: String? { get set }
    var notes: String? { get set }
    var imageName: String? { get set }
    var categories: [ShopCategoryProtocol] { get set }
    var hasNew: Bool { get set }
}
