
//
//  OSMapsAPI.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import OSMapProducts

/// Class used to construct stylesheets to be used with Mapbox
public class OSMapsAPI: NSObject {
    /// The API key to use with the API
    static var apiKey: String?

    /**
     Set the API key to use when accessing OS Maps.
     Calling this method configures the API to be ready to use.

     - parameter key: The api key to use
     */
    public class func setAPIKey(key: String) {
        apiKey = key
        NSURLProtocol.registerClass(OSMapsStyleProtocol)
    }

    /**
     Get a URL to be passed to a `MGLMapView`'s `styleURL` property

     - parameter product: The product to view

     - returns: A URL to pass
     */
    public class func stylesheetURLForProduct(product: OSBaseMapStyle) -> NSURL {
        let components = NSURLComponents()
        components.scheme = "osmaps"
        components.host = NSStringFromOSMapLayer(product, .WebMercator).stringByRemovingPercentEncoding
        return components.URL!
    }
}
