//
//  AdhderModel.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 05.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

public protocol AdhderModel {
}

public typealias AdhderModelCodable = AdhderModel & Codable

public extension AdhderModel where Self: Codable {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else {
            return nil
        }
        return from(data: data)
    }
    
    static func from(data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(Self.self, from: data)
    }
}
