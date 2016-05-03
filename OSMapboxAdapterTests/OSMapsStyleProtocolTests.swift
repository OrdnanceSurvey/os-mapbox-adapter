//
//  OSMapsStyleProtocolTests.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
import OSMapProducts
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

    func checkValue<T: Equatable>(dict: [String: AnyObject], key: String, expected: T) {
        if let val = dict[key] as? T {
            expect(val) == expected
        } else {
            fail("Couldn't find value \(key)")
        }
    }

    func runTestForBaseMapProduct(product: OSBaseMapStyle, expectedName: String) {
        OSMapsAPI.setAPIKey("test-key")
        let url = OSMapsAPI.stylesheetURLForProduct(product)

        let expectation = expectationWithDescription("fetched stylesheet")
        var receivedData: NSData?
        var receivedResponse: NSHTTPURLResponse?
        var receivedError: NSError?
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            receivedData = data
            receivedResponse = response as? NSHTTPURLResponse
            receivedError = error
            expectation.fulfill()
            }
            .resume()

        waitForExpectationsWithTimeout(1.0, handler: nil)

        expect(receivedError).to(beNil())
        expect(receivedResponse?.statusCode).to(equal(200))
        let dict = try! NSJSONSerialization.JSONObjectWithData(receivedData!, options: []) as! [String: AnyObject]
        checkValue(dict, key: "version", expected: 8)
        checkValue(dict, key: "name", expected: "OS Maps API")

        guard let tileSources = dict["sources"] as? [String: AnyObject],
            tileSource = tileSources[expectedName] as? [String: AnyObject] else {
                fail("No sources")
                return
        }
        checkValue(tileSource, key: "type", expected: "raster")
        checkValue(tileSource, key: "tileSize", expected: 256)
        guard let tileURL = (tileSource["tiles"] as? [String])?.first else {
            fail("No tile url")
            return
        }
        expect(tileURL).to(equal("https://api2.ordnancesurvey.co.uk/mapping_api/v1/service/zxy/EPSG%3A3857/\(expectedName)%203857/{z}/{x}/{y}.png?key=test-key"))
        guard let layers = dict["layers"] as? [[String: AnyObject]] else {
            fail("No layers found")
            return
        }
        expect(layers).to(haveCount(1))
        let layer = layers.first!
        checkValue(layer, key: "id", expected: expectedName)
        checkValue(layer, key: "type", expected: "raster")
        checkValue(layer, key: "source", expected: expectedName)
        checkValue(layer, key: "paint", expected: ["raster-fade-duration": 100])
    }

    func testItIsPossibleToFetchAStylesheetForTheRoadStack() {
        runTestForBaseMapProduct(.Road, expectedName: "Road")
    }

    func testItIsPossibleToFetchAStylesheetForTheOutdoorStack() {
        runTestForBaseMapProduct(.Outdoor, expectedName: "Outdoor")
    }

    func testItIsPossibleToFetchAStylesheetForTheLightStack() {
        runTestForBaseMapProduct(.Light, expectedName: "Light")
    }

    func testItIsPossibleToFetchAStylesheetForTheNightStack() {
        runTestForBaseMapProduct(.Night, expectedName: "Night")
    }

}
