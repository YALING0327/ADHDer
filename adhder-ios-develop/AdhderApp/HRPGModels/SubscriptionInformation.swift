//
//  SubscriptionInformation.swift
//  Adhder
//
//  Created by Phillip Thelen on 16/02/2017.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

import UIKit

class SubscriptionInformation {

    static let titles: [String] = [
        L10n.subscriptionInfo1Title,
        L10n.subscriptionInfo3Title,
        L10n.subscriptionInfo2Title,
        L10n.Subscription.infoFaintTitle,
        L10n.Subscription.infoArmoireTitle,
        L10n.subscriptionInfo5Title
    ]

    static let descriptions: [String] = [
        L10n.subscriptionInfo1Description,
        L10n.subscriptionInfo3Description,
        L10n.subscriptionInfo2Description,
        L10n.Subscription.infoFaintDescription,
        L10n.Subscription.infoArmoireDescription,
        L10n.subscriptionInfo5Description
    ]
    
    static let images: [UIImage?] = [
        Asset.subBenefitsGems.image,
        nil,
        Asset.subBenefitsHourglasses.image,
        Asset.subBenefitsFaint.image,
        Asset.subBenefitsArmoire.image,
        Asset.subBenefitDrops.image
    ]
}
