//
//  MapViewController.swift
//  Atlas
//
//  Created by Jack Cook on 7/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MapboxGL
import UIKit

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var statusBarContainer: UIView!
    @IBOutlet var mapViewContainer: UIView!
    
    var mapView: MGLMapView!
    
    let north = 40.915568
    let east = -73.699215
    let west = -74.257159
    let south = 40.495992
    
    let maxZoom = 11.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let styleURL = NSURL(string: "asset://styles/emerald-v7.json")!
        
        self.mapView = MGLMapView(frame: mapViewContainer.bounds, styleURL: styleURL)
        
        self.mapView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.mapView.attributionButton.alpha = 0
        self.mapView.logoView.alpha = 0
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), zoomLevel: 12, animated: false)
        mapViewContainer.addSubview(self.mapView)
        
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.drawPolyline()
        })
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkCoordinate", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func drawPolyline() {
        var coordinates = [CLLocationCoordinate2D(latitude: 40.915568, longitude: -74.257159), CLLocationCoordinate2D(latitude: 40.915568, longitude: -73.699215), CLLocationCoordinate2D(latitude: 40.495992, longitude: -73.699215), CLLocationCoordinate2D(latitude: 40.495992, longitude: -74.257159), CLLocationCoordinate2D(latitude: 40.915568, longitude: -74.257159)]
        var polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.addAnnotation(polyline)
        })
    }
    
    func checkCoordinate() {
        let center = self.mapView.centerCoordinate
        let lat = center.latitude
        let lon = center.longitude
        
        let outsideNorth = lat > north
        let outsideEast = lon > east
        let outsideWest = lon < west
        let outsideSouth = lat < south
        
        let outsideZoom = self.mapView.zoomLevel < maxZoom
        
        let outside = outsideNorth || outsideEast || outsideWest || outsideSouth || outsideZoom
        
        var newCoordinate = self.mapView.centerCoordinate
        var newZoom = outsideZoom ? maxZoom : self.mapView.zoomLevel
        
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
            
            println("setting new coordinates \(newCoordinate.latitude), \(newCoordinate.longitude) with zoom level \(newZoom)")
            
            self.mapView.setCenterCoordinate(newCoordinate, zoomLevel: newZoom, animated: true)
        }
    }
}
