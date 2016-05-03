//
//  OSMapsAPITests.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
@testable import OSMapboxAdapter

class OSMapsAPITests: XCTestCase {

    func testItIsPossibleToSetTheAPIKey() {
        OSMapsAPI.setAPIKey("testKey")
        expect(OSMapsAPI.apiKey).to(equal("testKey"))
    }

    func testItIsPossibleToGetAURLForAStyle() {
        let url = OSMapsAPI.stylesheetURLForProduct(.Road)
        expect(url.absoluteString).to(equal("osmaps://Road%203857"))
    }

}
