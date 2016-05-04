//
//  ViewController.swift
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 03/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import UIKit
import Mapbox
import OSMapboxAdapter

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!

    var apiKey: String {
        return NSBundle.mainBundle().URLForResource("APIKEY", withExtension: nil).flatMap { url -> String? in
            do { return try String(contentsOfURL: url).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) } catch { return nil }
            } ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        OSMapsAPI.setAPIKey(apiKey)
        mapView.styleURL = OSMapsAPI.stylesheetURLForProduct(.Road)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 50.9386, longitude: -1.4705)
        mapView.zoomLevel = 10
    }

}

