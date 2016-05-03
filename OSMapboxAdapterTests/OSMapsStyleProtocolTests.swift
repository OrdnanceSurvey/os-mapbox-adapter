//
//  OSMapsStyleProtocolTests.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
@testable import OSMapboxAdapter

class OSMapsStyleProtocolTests: XCTestCase {

    func testItCanHandleAnOSMapsProtocol() {
        let goodURL = NSURL(string: "osmaps://road")!
        let goodRequest = NSURLRequest(URL: goodURL)
        expect(OSMapsStyleProtocol.canInitWithRequest(goodRequest)).to(beTrue())
    }

    func testItDoesntHandleOtherProtocols() {
        let badURL = NSURL(string: "http://os.co.uk")!
        let badRequest = NSURLRequest(URL: badURL)
        expect(OSMapsStyleProtocol.canInitWithRequest(badRequest)).to(beFalse())
        let emptyRequest = NSURLRequest()
        expect(OSMapsStyleProtocol.canInitWithRequest(emptyRequest)).to(beFalse())
    }

}
