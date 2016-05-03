//
//  OSMapsStyleProtocol.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import OSMapProducts

/// URL protocol used to return stylesheets that can be used with Mapbox
class OSMapsStyleProtocol: NSURLProtocol {

    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        guard let url = request.URL else {
            return false
        }
        return url.scheme == "osmaps"
    }

    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }

    func productFromURL(url: NSURL) -> OSBaseMapStyle {
        return OSStyleFromLayerName(url.host!.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet()))
    }

    func tileSourceForProduct(product: OSBaseMapStyle) -> [String: AnyObject] {
        let spatial = "EPSG:\(OSWkIDFromSpatialReference(.WebMercator))".stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!
        let product = NSStringFromOSMapLayer(product, .WebMercator)
        guard let apiKey = OSMapsAPI.apiKey else {
            return [:]
        }
        return [
            "type": "raster",
            "tileSize": 256,
            "tiles": [
                "https://api2.ordnancesurvey.co.uk/mapping_api/v1/service/zxy/\(spatial)/\(product)/{z}/{x}/{y}.png?key=\(apiKey)"
            ]
        ]
    }

    func layerForProduct(product: OSBaseMapStyle) -> [String: AnyObject] {
        let productName = NSStringFromOSBaseMapStyle(product)
        return [
            "id": productName,
            "type": "raster",
            "source": productName,
            "paint": [
                "raster-fade-duration": 100
            ]
        ]
    }

    override func startLoading() {
        var style = [
            "version": 8,
            "name": "OS Maps API"
            ]
        guard let url = request.URL else {
            return
        }
        let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: nil)!
        let product = productFromURL(url)
        style["sources"] = [
            NSStringFromOSBaseMapStyle(product): tileSourceForProduct(product)
        ]
        style["layers"] = [
            layerForProduct(product)
        ]

        guard let data = try? NSJSONSerialization.dataWithJSONObject(style, options: []) else {
            return
        }
        client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        client?.URLProtocol(self, didLoadData: data)
        client?.URLProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
