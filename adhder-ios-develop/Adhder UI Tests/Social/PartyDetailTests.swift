//
//  PartyDetailTests.swift
//  Adhder UI Tests
//
//  Created by Phillip Thelen on 11.03.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import XCTest

class PartyDetailTests: AdhderAppTests {
    let url = "/groups/party"
    
    override func setUp() {
        super.setUp()
        stubData["user"] = stubFileResponse(name: "user")
        stubData["groups/MOCKPARTY"] = stubFileResponse(name: "party")
        stubData["groups/MOCKPARTY/members"] = stubFileResponse(name: "party-members")
        stubData["groups/MOCKPARTY/chat"] = stubEmptyListResponse()
    }

    func testShowsQuestProgress() {
        app.launch(withStubs: stubData, toUrl: url)
        
        expectExists(app.staticTexts["1 Participants"])
        expectExists(app.staticTexts["Anti'zinnya"])
        expectExists(app.staticTexts["Siphoning Void"])
    }
}
