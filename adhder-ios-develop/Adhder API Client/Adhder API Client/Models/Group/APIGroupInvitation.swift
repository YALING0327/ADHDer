//
//  APIGroupInvitation.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 22.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models

struct APIGroupInvitationHelper: Decodable {
    var guilds: [APIGroupInvitation]?
    var parties: [APIGroupInvitation]?
}

class APIGroupInvitation: GroupInvitationProtocol, Decodable {
    var isValid: Bool = true
    var isManaged: Bool = false
    
    var id: String?
    var name: String?
    var inviterID: String?
    var isPartyInvitation: Bool = false
    var isPublicGuild: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case inviterID = "inviter"
        case isPublicGuild = "publicGuild"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        inviterID = try? values.decode(String.self, forKey: .inviterID)
        isPublicGuild = (try? values.decode(Bool.self, forKey: .isPublicGuild)) ?? false
    }
}
