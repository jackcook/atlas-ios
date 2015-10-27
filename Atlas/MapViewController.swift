//
//  MapViewController.swift
//  Atlas
//
//  Created by Jack Cook on 7/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Mapbox
import SwiftyJSON
import UIKit

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var statusBarContainer: UIView!
    @IBOutlet var mapViewContainer: UIView!
    
    var mapView: MGLMapView!
    
    let north = 40.915568
    let east = -73.699215
    let west = -74.257159
    let south = 40.495992
    
    let maxZoom = 10.5
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let styleURL = NSURL(string: "asset://styles/emerald-v8.json")!
        
        self.mapView = MGLMapView(frame: mapViewContainer.bounds, styleURL: styleURL)
        self.mapView.delegate = self
        
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.mapView.attributionButton.alpha = 0
        self.mapView.logoView.alpha = 0
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), zoomLevel: 11, animated: false)
        mapViewContainer.addSubview(self.mapView)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkCoordinate", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        let tgr = UITapGestureRecognizer(target: self, action: "tapped:")
        tgr.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(tgr)
    }
    
    func tapped(tgr: UITapGestureRecognizer) {
        let point = tgr.locationInView(self.mapView)
        let coordinate = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        
        let key = "AIzaSyArAbdik6IOVHoFufQo1q_ouSbeqYP9-m0"
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(key)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=100")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let json = JSON(data: data!)
            if let results = json["results"].array {
                for result in results {
                    if let types = result["types"].array {
                        var stringTypes = [String]()
                        for type in types {
                            if let type = type.string {
                                stringTypes.append(type)
                            }
                        }
                        
                        if stringTypes.contains("neighborhood") {
                            continue
                        } else {
                            if let name = result["name"].string {
                                print("(\(coordinate.latitude), \(coordinate.longitude)) -> \(name)")
                                break
                            }
                        }
                    }
                }
            }
        }
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
        let newZoom = outsideZoom ? maxZoom : self.mapView.zoomLevel
        
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
            
            print("setting new coordinates \(newCoordinate.latitude), \(newCoordinate.longitude) with zoom level \(newZoom)")
            
            self.mapView.setCenterCoordinate(newCoordinate, zoomLevel: newZoom, animated: true)
        }
    }
}
