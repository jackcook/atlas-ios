//
//  MapViewController.swift
//  Atlas
//
//  Created by Jack Cook on 7/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MapboxGL
import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet var statusBarContainer: UIView!
    @IBOutlet var mapViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let styleURL = NSURL(string: "asset://styles/light-v7.json")!
        
        let mapView = MGLMapView(frame: mapViewContainer.bounds, styleURL: styleURL)
        mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        mapView.attributionButton.alpha = 0
        mapView.logoView.alpha = 0
        
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), zoomLevel: 12, animated: false)
        mapViewContainer.addSubview(mapView)
    }
}
