//
//  GroupInvitationProtocol.swift
//  Adhder Models
//
//  Created by Phillip Thelen on 22.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
public protocol GroupInvitationProtocol: BaseModelProtocol {
    var id: String? { get set }
    var name: String? { get set }
    var inviterID: String? { get set }
    var isPartyInvitation: Bool { get set }
    var isPublicGuild: Bool { get set }
}
