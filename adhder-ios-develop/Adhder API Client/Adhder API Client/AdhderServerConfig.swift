//
//  AdhderServerConfig.swift
//  Adhder
//
//  Created by Elliot Schrock on 9/20/17.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

public class AdhderServerConfig {
    public static let production = ServerConfiguration(scheme: "https", host: Constants.defaultProdHost, apiRoute: "api/\(Constants.defaultApiVersion)")
    
    public static let staging = ServerConfiguration(scheme: "https", host: "staging.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    
    public static let bat = ServerConfiguration(scheme: "https", host: "bat.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let frog = ServerConfiguration(scheme: "https", host: "frog.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let llama = ServerConfiguration(scheme: "https", host: "llama.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let monkey = ServerConfiguration(scheme: "https", host: "monkey.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let seal = ServerConfiguration(scheme: "https", host: "seal.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let shrimp = ServerConfiguration(scheme: "https", host: "shrimp.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let starfish = ServerConfiguration(scheme: "https", host: "starfish.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let turtle = ServerConfiguration(scheme: "https", host: "turtle.adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")


    public static let localhost = ServerConfiguration(scheme: "http", host: "192.168.178.52:3000", apiRoute: "api/\(Constants.defaultApiVersion)")
    public static let stub = ServerConfiguration(shouldStub: true, scheme: "https", host: "adhder.com", apiRoute: "api/\(Constants.defaultApiVersion)")
    
    public static var current = production
        
    public static var etags: [String: String] = [:]
    
    public static var stubs = [String: CallStub]()
    
    public static func from(_ configName: String) -> ServerConfiguration {
        switch configName {
        case "staging":
            return AdhderServerConfig.staging
        case "bat":
            return AdhderServerConfig.bat
        case "frog":
            return AdhderServerConfig.frog
        case "llama":
            return AdhderServerConfig.llama
        case "monkey":
            return AdhderServerConfig.monkey
        case "seal":
            return AdhderServerConfig.seal
        case "shrimp":
            return AdhderServerConfig.shrimp
        case "starfish":
            return AdhderServerConfig.starfish
        case "turtle":
            return AdhderServerConfig.turtle
        default:
            return AdhderServerConfig.production
        }
    }
}
