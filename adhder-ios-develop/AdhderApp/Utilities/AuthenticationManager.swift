//
//  AuthenticationManager.swift
//  Adhder
//
//  Created by Phillip on 29.08.17.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import KeychainAccess
import Adhder_API_Client

protocol AuthenticationStorage {
    var userID: String? { get set }
    var apiKey: String? { get set }
}

class KeychainAuthenticationStorage: AuthenticationStorage {
    private let localKeychain = Keychain(service: "com.adhderapp.ios.Adhder", accessGroup: "group.adhderapp.adhder")

    private var keychain: Keychain {
        return Keychain(server: "https://adhder.com", protocolType: .https)
            .accessibility(.afterFirstUnlock)
    }
    
    var userID: String? {
        get {
            // using this to bootstrap identification so user's don't have to re-log in
            guard let cuid = localKeychain["currentUserId"] else {
                let cuid = UserDefaults.standard.string(forKey: "currentUserId")
                localKeychain["currentUserId"] = cuid
                return cuid
            }
            return cuid
        }

        set(newUserId) {
            localKeychain["currentUserId"] = newUserId
        }
    }
    
    var apiKey: String? {
        get {
            if let userID = userID {
                let userKey = keychain[userID]
                if userKey != nil {
                    localKeychain[userID] = userKey
                    return userKey
                } else {
                    return localKeychain[userID]
                }
            }
            return nil
        }

        set(newKey) {
            if let userID = userID {
                keychain[userID] = newKey
                localKeychain[userID] = newKey
            }
        }
    }
}

class MemoryAuthenticationStorage: AuthenticationStorage {
    var userID: String?
    var apiKey: String?
}

class AuthenticationManager {

    func initialize(withStorage storage: AuthenticationStorage) {
        self.storage = storage
        // This is to properly run the setters so that the app is correctly configured
        currentUserId = storage.userID
        currentUserKey = storage.apiKey
    }
    
    static let shared = AuthenticationManager()
    var storage: AuthenticationStorage?

    var currentUserId: String? {
        get {
            return storage?.userID
        }
        
        set(newValue) {
            storage?.userID = newValue
            currentUserIDProperty.value = newValue
            UserDefaults.standard.set(newValue, forKey: "currentUserId")
            NetworkAuthenticationManager.shared.currentUserId = newValue
            if let newID = newValue {
                (logger as? RemoteLogger)?.setUserID(newID)
                AdhderAnalytics.shared.setUserID(newID)
            } else {
                (logger as? RemoteLogger)?.setUserID(nil)
                AdhderAnalytics.shared.setUserID(nil)
            }
        }
    }

    var currentUserIDProperty = MutableProperty<String?>(nil)

    var currentUserKey: String? {
        get {
            return storage?.apiKey
        }
        
        set(newValue) {
            storage?.apiKey = newValue
            NetworkAuthenticationManager.shared.currentUserKey = newValue
        }
    }

    private init() {
        currentUserIDProperty.value = currentUserId
    }

    func hasAuthentication() -> Bool {
        return currentUserId?.isEmpty == false && currentUserKey?.isEmpty == false
    }

    func setAuthentication(userId: String, key: String) {
        currentUserId = userId
        currentUserKey = key
    }

    func clearAuthenticationForAllUsers() {
        currentUserId = nil
        currentUserKey = nil
    }

    func clearAuthentication(userId: String) {
        // Will be used once we support multiple users
        clearAuthenticationForAllUsers()
    }
}
