//
//  FeedPetCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 17.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class FeedPetCall: ResponseObjectCall<Int, Int> {
    public init(pet: String, food: String) {
        super.init(httpMethod: .POST, endpoint: "user/feed/\(pet)/\(food)", postData: nil)
    }
}
