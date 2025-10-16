//
//  RemoteLogger.swift
//  Adhder
//
//  Created by Phillip Thelen on 22.01.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import Foundation

class RemoteLogger: AdhderLogger {    
    override func record(error: Error) {
    }
    
    override func record(name: String, reason: String) {
    }
    
    override func log(format: String, level: LogLevel = .debug, arguments: CVaListPointer) {

    }
    
    public func setUserID(_ userID: String?) {
    }
}
