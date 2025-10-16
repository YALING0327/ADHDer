//
//  MountDetailTests.swift
//  Adhder UI Tests
//
//  Created by Phillip Thelen on 11.03.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import XCTest
import Adhder_Models

class MountDetailTests: AdhderAppTests {

    private let url = "/inventory/stable/mounts/Fox"
    
    override func setUp() {
        super.setUp()
        stubData["user"] = stubFileResponse(name: "user")
        stubData["user/equip/pet/Fox-Base"] = CallStub(responses: [
            AdhderAppTests.wrapResponse(string: "{\"currentPet\": \"Fox-Base\"}"),
            AdhderAppTests.wrapResponse(string: "{\"currentPet\": \"\"}")
        ])
    }

    func testListingMounts() {
        app.launch(withStubs: stubData, toUrl: url)
        
        let collection = app.collectionViews.firstMatch
        expectExists(collection.cells["Red Fox"])
        expectExists(collection.cells["White Fox"])
        expectExists(collection.cells["Unknown Mount"])
    }

    func testEquippingMount() {
        app.launch(withStubs: stubData, toUrl: url)
        
        let collection = app.collectionViews.firstMatch
        collection.cells["Base Fox"].tap()
        app.sheets["Base Fox"].buttons["Equip"].tap()
        sleep(1)
        collection.cells["Base Fox"].tap()
        app.sheets["Base Fox"].buttons["Unequip"].tap()
        collection.cells["Base Fox"].tap()
        expectExists(app.sheets["Base Fox"].buttons["Equip"])
    }
}
