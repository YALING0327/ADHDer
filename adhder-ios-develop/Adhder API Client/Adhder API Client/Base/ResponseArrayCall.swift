//
//  ResponseArrayCall.swift
//  Adhder
//
//  Created by Elliot Schrock on 9/20/17.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//
import Foundation
import ReactiveSwift

public class ResponseArrayCall<T: Any, C: Decodable>: AdhderResponseCall<[T], [C]> {
    public lazy var arraySignal: Signal<[T]?, Never> = adhderResponseSignal.skipNil().map { (adhderResponse) in
        return adhderResponse.data as? [T]
    }
}
