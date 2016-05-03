//
//  OSMapsStyleProtocol.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/// URL protocol used to return stylesheets that can be used with Mapbox
class OSMapsStyleProtocol: NSURLProtocol {
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        guard let url = request.URL else {
            return false
        }
        return url.scheme == "osmaps"
    }
}
