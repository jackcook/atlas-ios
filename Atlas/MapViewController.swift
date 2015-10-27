//
//  MapViewController.swift
//  Atlas
//
//  Created by Jack Cook on 7/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MapKit
import SwiftyJSON
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var statusBarContainer: UIView!
    @IBOutlet var mapViewContainer: UIView!
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    
    var startingHeight: CGFloat!
    var positioningTimer: NSTimer!
    
    let north = 40.915568
    let east = -73.699215
    let west = -74.257159
    let south = 40.495992
    
    let maxAltitude: CLLocationDistance = 50000
    var empireStateBuilding: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        
        self.mapView = MKMapView(frame: mapViewContainer.bounds)
        self.mapView.delegate = self
        
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.mapView.showsBuildings = false
        self.mapView.showsPointsOfInterest = true
        self.mapView.showsUserLocation = true
        
        let center = CLLocationCoordinate2D(latitude: 40.7470, longitude: -73.9860)
        let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromEyeCoordinate: center, eyeAltitude: 25000)
        self.mapView.setCamera(camera, animated: false)
        
        mapViewContainer.addSubview(self.mapView)
        
        self.empireStateBuilding = MKPointAnnotation()
        self.empireStateBuilding.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
        
        self.mapView.addAnnotation(self.empireStateBuilding)
        
        let tgr = UITapGestureRecognizer()
        tgr.numberOfTapsRequired = 1
        tgr.addTarget(self, action: "go")
        self.mapView.addGestureRecognizer(tgr)
    }
    
    func go() {
        self.mapView.camera.altitude = 200
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.startingHeight = CGFloat(self.mapView.camera.altitude)
        self.positioningTimer = NSTimer(timeInterval: 0.1, target: self, selector: "updateAnnotations", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.positioningTimer, forMode: NSRunLoopCommonModes)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.positioningTimer.invalidate()
        self.positioningTimer = nil
        
        self.checkCoordinate()
    }
    
    let multiplier = UIScreen.mainScreen().bounds.height < 700 ? (UIScreen.mainScreen().bounds.height < 600 ? (UIScreen.mainScreen().bounds.height < 500 ? 1.4 : 1.2) : 1) : 0.83
    
    func updateAnnotations() {
        let constant = 0.0004825935724
        let altitude = floor(self.mapView.region.span.latitudeDelta / constant * 100) * multiplier
        
        if altitude > 35000 {
            self.mapView.removeAnnotation(self.empireStateBuilding)
        } else {
            self.mapView.addAnnotation(self.empireStateBuilding)
        }
    }
    
    func checkCoordinate() {
        let center = self.mapView.camera.centerCoordinate
        let lat = center.latitude
        let lon = center.longitude
        
        let outsideNorth = lat > north
        let outsideEast = lon > east
        let outsideWest = lon < west
        let outsideSouth = lat < south
        
        let outsideAltitude = self.mapView.camera.altitude > maxAltitude
        
        let outside = outsideNorth || outsideEast || outsideWest || outsideSouth || outsideAltitude
        
        var newCoordinate = self.mapView.camera.centerCoordinate
        let newAltitude = outsideAltitude ? maxAltitude : self.mapView.camera.altitude
        
        if outside {
            if outsideNorth {
                newCoordinate.latitude = north
            } else if outsideSouth {
                newCoordinate.latitude = south
            }
            
            if outsideEast {
                newCoordinate.longitude = east
            } else if outsideWest {
                newCoordinate.longitude = west
            }
            
            print("setting new coordinates \(newCoordinate.latitude), \(newCoordinate.longitude) with altitude \(newAltitude)")
            
//            let camera = MKMapCamera(lookingAtCenterCoordinate: newCoordinate, fromDistance: newAltitude, pitch: 0, heading: 0)
            let camera = MKMapCamera(lookingAtCenterCoordinate: newCoordinate, fromEyeCoordinate: newCoordinate, eyeAltitude: newAltitude)
            self.mapView.setCamera(camera, animated: true)
        }
    }
}
