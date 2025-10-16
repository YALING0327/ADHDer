//
//  UpdateTagCall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

public class UpdateTagCall: ResponseObjectCall<TagProtocol, APITag> {
    public init(tag: TagProtocol) {
        let encoder = JSONEncoder()
        encoder.setAdhderDateEncodingStrategy()
        let json = try? encoder.encode(APITag(tag))
        super.init(httpMethod: .PUT, endpoint: "tags/\(tag.id ?? "")", postData: json)
    }
}
