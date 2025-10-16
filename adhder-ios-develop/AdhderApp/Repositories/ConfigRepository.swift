//
//  RemoteConfigRepository.swift
//  Adhder
//
//  Created by Phillip Thelen on 16/03/2017.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//
import Foundation
import Adhder_API_Client
import FirebaseRemoteConfig
import Adhder_Models

@objc
enum ConfigVariable: Int {
    // Permanent config variables
    case supportEmail
    case twitterUsername
    case instagramUsername
    case appstoreUrl
    case prodHost
    case apiVersion
    case feedbackURL
    
    case shopSpriteSuffix
    case maxChatLength
    case spriteSubstitutions
    case lastVersionNumber
    case lastVersionCode
    case randomizeAvatar
    case showSubscriptionBanner
    case raiseShops
    case knownIssues
    case activePromotion
    case customMenu
    case maintenanceData
    case activePromo
    case surveyURL
    
    // A/B Tests
    case moveAdventureGuide
    case enableUsernameAutocomplete
    case reorderMenu
    case enableIPadUI
    case showQuestInMenu
    case disableIntroSlides
    case showTaskDetailScreen
    case showTaskGraphs
    case advertiseTaskGraphs
    
    case enableCronButton
    
    case hideChallenges
    
    case enableFaintSubs
    case enableArmoireSubs
    case enableCustomizationShop
    case enableReviewRequest

    // swiftlint:disable cyclomatic_complexity
    func name() -> String {
        // swiftlint:disable switch_case_on_newline
        switch self {
        case .supportEmail: return "supportEmail"
        case .twitterUsername: return "twitterUsername"
        case .instagramUsername: return "instagramUsername"
        case .appstoreUrl: return "appstoreUrl"
        case .prodHost: return "prodHost"
        case .apiVersion: return "apiVersion"
        case .shopSpriteSuffix: return "shopSpriteSuffix"
        case .maxChatLength: return "maxChatLength"
        case .enableUsernameAutocomplete: return "enableUsernameAutocomplete"
        case .spriteSubstitutions: return "spriteSubstitutions"
        case .lastVersionNumber: return "lastVersionNumber"
        case .lastVersionCode: return "lastVersionCode"
        case .randomizeAvatar: return "randomizeAvatar"
        case .showSubscriptionBanner: return "showSubscriptionBanner"
        case .raiseShops: return "raiseShops"
        case .feedbackURL: return "feedbackURL"
        case .moveAdventureGuide: return "moveAdventureGuide"
        case .knownIssues: return "knownIssues"
        case .activePromotion: return "activePromo"
        case .customMenu: return "customMenu"
        case .maintenanceData: return "maintenanceData"
        case .reorderMenu: return "reorderMenu"
        case .enableIPadUI: return "enableIpadUI"
        case .showQuestInMenu: return "showQuestInMenu"
        case .disableIntroSlides: return "disableIntroSlides"
        case .showTaskDetailScreen: return "showTaskDetailScreen"
        case .activePromo: return "activePromo"
        case .surveyURL: return "surveyURL"
        case .showTaskGraphs: return "showTaskGraphs"
        case .advertiseTaskGraphs: return "advertiseTaskGraphs"
        case .enableCronButton: return "enableCronButton"
        case .hideChallenges: return "hideChallenges"
        case .enableFaintSubs: return "enableFaintSubs"
        case .enableArmoireSubs: return "enableArmoireSubs"
        case .enableCustomizationShop: return "enableCustomizationShop"
        case .enableReviewRequest: return "enableReviewRequest"
        }
        // swiftlint:enable switch_case_on_newline
    }

    func defaultValue() -> NSObject {
        switch self {
        case .supportEmail:
            return "admin@adhder.com" as NSString
        case .twitterUsername:
            return Constants.defaultTwitterUsername as NSString
        case .instagramUsername:
            return Constants.defaultInstagramUsername as NSString
        case .appstoreUrl:
            return Constants.defaultAppstoreUrl as NSString
        case .prodHost:
            return Constants.defaultProdHost as NSString
        case .apiVersion:
            return Constants.defaultApiVersion as NSString
        case .shopSpriteSuffix:
            return "" as NSString
        case .maxChatLength:
            return 3000 as NSNumber
        case .enableUsernameAutocomplete:
            return false as NSNumber
        case .spriteSubstitutions:
            return "{}" as NSString
        case .lastVersionNumber:
            return "" as NSString
        case .lastVersionCode:
            return 0 as NSNumber
        case .randomizeAvatar:
            return false as NSNumber
        case .raiseShops:
            return false as NSNumber
        case .moveAdventureGuide:
            return false as NSNumber
        case .feedbackURL:
            return "https://docs.google.com/forms/d/e/1FAIpQLScPhrwq_7P1C6PTrI3lbvTsvqGyTNnGzp1ugi1Ml0PFee_p5g/viewform?usp=sf_link" as NSString
        case .knownIssues:
            return "[]" as NSString
        case .activePromotion:
            return "" as NSString
        case .customMenu:
            return "[]" as NSString
        case .showSubscriptionBanner:
            return false as NSNumber
        case .maintenanceData:
            return "{}" as NSString
        case .reorderMenu:
            return false as NSNumber
        case .enableIPadUI:
            return false as NSNumber
        case .showQuestInMenu:
            return false as NSNumber
        case .disableIntroSlides:
            return false as NSNumber
        case .showTaskDetailScreen:
            return false as NSNumber
        case .activePromo:
            return "" as NSString
        case .surveyURL:
            return "" as NSString
        case .showTaskGraphs:
            return true as NSNumber
        case .advertiseTaskGraphs:
            return false as NSNumber
        case .enableCronButton:
            return false as NSNumber
        case .enableFaintSubs:
            return false as NSNumber
        case .enableArmoireSubs:
            return false as NSNumber
        case .hideChallenges:
            return false as NSNumber
        case .enableCustomizationShop:
            return false as NSNumber
        case .enableReviewRequest:
            return false as NSNumber
        }
    }
    
    static func allVariables() -> [ConfigVariable] {
        return [
            .supportEmail,
            .twitterUsername,
            .instagramUsername,
            .appstoreUrl,
            .prodHost,
            .apiVersion,
            .shopSpriteSuffix,
            .maxChatLength,
            .enableUsernameAutocomplete,
            .spriteSubstitutions,
            .lastVersionNumber,
            .lastVersionCode,
            .randomizeAvatar,
            .raiseShops,
            .feedbackURL,
            .moveAdventureGuide,
            .knownIssues,
            .activePromotion,
            .customMenu,
            .maintenanceData,
            .reorderMenu,
            .enableIPadUI,
            .showQuestInMenu,
            .disableIntroSlides,
            .activePromo,
            .surveyURL,
            .showTaskGraphs,
            .advertiseTaskGraphs,
            .enableCronButton,
            .enableFaintSubs,
            .enableArmoireSubs,
            .hideChallenges,
            .enableCustomizationShop
        ]
    }
    // swiftlint:enable cyclomatic_complexity
}

enum TestingLevel: String {
    case production
    case beta
    case staff
    case debug
    case simulator
    
    var isTrustworthy: Bool {
        if self == .production || self == .beta {
            return false
        } else {
            return true
        }
    }
    
    var isDeveloper: Bool {
        if self == .debug || self == .simulator {
            return true
        } else {
            return false
        }
    }
}

@objc
class ConfigRepository: NSObject {
    @objc public static let shared = ConfigRepository()
    
    private override init() {
        super.init()
    }

    private static let remoteConfig = RemoteConfig.remoteConfig()
    private let userConfig = UserDefaults.standard
    private let contentRepository = ContentRepository()

    private var worldState: WorldStateProtocol?
    
    static var onFetchCompleted: (() -> Void)?
    static var hasFetched: Bool {
        return remoteConfig.lastFetchStatus == .success
    }
    @objc
    func fetchremoteConfig() {
        ConfigRepository.remoteConfig.fetch(withExpirationDuration: AdhderAppDelegate.isRunningLive() ? 3600 : 0) { (_, _) in
            ConfigRepository.remoteConfig.activate(completion: { _, _ in
                if let action = ConfigRepository.onFetchCompleted {
                    action()
                }
            })
        }
        var defaults = [String: NSObject]()
        for variable in ConfigVariable.allVariables() {
            defaults[variable.name()] = variable.defaultValue()
        }
        ConfigRepository.remoteConfig.setDefaults(defaults)
        contentRepository.getWorldState().on(value: {[weak self] state in
            self?.worldState = state
            var hasAprilFools = false
            for event in state.events {
                if let aprilFools = event.aprilFools {
                    EventHelper.setup(event: aprilFools, endDate: event.end)
                    hasAprilFools = true
                }
            }
            if !hasAprilFools {
                EventHelper.disableAll()
            }
        }).start()
    }

    var testingLevel: TestingLevel {
        #if targetEnvironment(simulator)
            return .simulator
        #else
        let value = Bundle.main.infoDictionary?["TESTING_LEVEL"] as? String
        switch value {
        case "debug":
            return .debug
        case "staff":
            return .staff
        case "beta":
            return .beta
        default:
            return .production
        }
#endif
    }
    
    @objc
    func bool(variable: ConfigVariable) -> Bool {
        #if DEBUG
        if testingLevel.isDeveloper {
            return variable.defaultValue()
        }
        #endif
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).boolValue
    }

    @objc
    func string(variable: ConfigVariable) -> String? {
        if variable == .shopSpriteSuffix {
            for event in worldState?.events ?? [] where event.npcImageSuffix?.isEmpty == false {
                return event.npcImageSuffix
            }
            return nil
        }
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).stringValue
    }
    
    @objc
    func string(variable: ConfigVariable, defaultValue: String) -> String {
        return string(variable: variable) ?? defaultValue
    }
    
    @objc
    func integer(variable: ConfigVariable) -> Int {
        return ConfigRepository.remoteConfig.configValue(forKey: variable.name()).numberValue.intValue
    }
    
    @objc
    func dictionary(variable: ConfigVariable) -> NSDictionary {
        let configString = ConfigRepository.remoteConfig.configValue(forKey: variable.name()).stringValue
        if let data = configString.data(using: String.Encoding.utf8) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let jsonDictionary = json as? NSDictionary {
                    return jsonDictionary
                }
            }
        }
        return NSDictionary()
    }
    
    @objc
    func array(variable: ConfigVariable) -> NSArray {
        let configString = ConfigRepository.remoteConfig.configValue(forKey: variable.name()).stringValue
        if let data = configString.data(using: String.Encoding.utf8) {
            do {
                try JSONSerialization.jsonObject(with: data, options: [])
            } catch let error {
                logger.log(error)
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let jsonArray = json as? NSArray {
                    return jsonArray
                }
            }
        }
        return NSArray()
    }
    
    func activePromotion() -> AdhderPromotion? {
        var promo: AdhderPromotion?
        for event in worldState?.events ?? [] where AdhderPromotionType.getPromoFromKey(key: event.promo ?? event.eventKey ?? "", startDate: event.start, endDate: event.end) != nil {
            promo = AdhderPromotionType.getPromoFromKey(key: event.promo ?? event.eventKey ?? "", startDate: event.start, endDate: event.end)
        }
        if promo == nil, let key = string(variable: .activePromo), key.isEmpty == false {
            promo = AdhderPromotionType.getPromoFromKey(key: key, startDate: nil, endDate: nil)
        }
        if let promo = promo, promo.endDate > Date() {
            return promo
        } else {
            return nil
        }
    }
    
    func enableIPadUI() -> Bool {
        if isOnMac {
            return true
        }
        return bool(variable: .enableIPadUI)
    }
    
    let isOnMac: Bool = {
        #if targetEnvironment(macCatalyst)
            return true
        #else
            return ProcessInfo.processInfo.isiOSAppOnMac
        #endif
    }()
    
    func getBirthdayEvent() -> WorldStateEventProtocol? {
        for event in worldState?.events ?? [] where event.eventKey == "birthday10" {
            if let end = event.end, end > Date() {
                return event
            }
            break
        }
        return nil
    }
}
