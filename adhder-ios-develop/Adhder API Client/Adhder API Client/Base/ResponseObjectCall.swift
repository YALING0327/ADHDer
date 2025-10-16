//
//  ResponseObjectCall.swift
//  Adhder
//
//  Created by Elliot Schrock on 9/30/17.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//
import Foundation
import ReactiveSwift

public class ResponseObjectCall<T: Any, C: Decodable>: AdhderResponseCall<T, C> {
    public lazy var objectSignal: Signal<T?, Never> = adhderResponseSignal.skipNil().map { (adhderResponse) in
        return adhderResponse.data as? T
    }
}
