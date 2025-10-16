//
// Created by Phillip Thelen on 02.05.18.
// Copyright (c) 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveGroupMembersCall: ResponseArrayCall<MemberProtocol, APIMember> {
    public init(groupID: String) {
        super.init(httpMethod: .GET, endpoint: "groups/\(groupID)/members?includeAllPublicFields=true")
    }
}
