//
//  Adhder_UI_Tests.swift
//  Adhder UI Tests
//
//  Created by Phillip Thelen on 09.03.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import XCTest

class Adhder_UI_Tests: XCTestCase {

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
