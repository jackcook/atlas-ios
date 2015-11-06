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
    
    var places = Array<Place>()
    var annotations = Array<PlaceAnnotation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let url = NSURL(string: "http://10.0.1.6:5000/places")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let _ = error {
                print(error)
                print("error retrieving places")
            } else {
                if let places = JSON(data: data!).array {
                    for obj in places {
                        let place = Place(data: obj)
                        self.places.append(place)
                        
                        let annotation = place.annotation()
                        self.annotations.append(annotation)
                    }
                }
            }
        }
        
        task.resume()
        
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        
        self.mapView = MKMapView(frame: mapViewContainer.bounds)
        self.mapView.delegate = self
        
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.mapView.showsBuildings = false
        self.mapView.showsPointsOfInterest = false
        self.mapView.showsUserLocation = true
        
        let center = CLLocationCoordinate2D(latitude: 40.7470, longitude: -73.9860)
        let camera = MKMapCamera(lookingAtCenterCoordinate: center, fromEyeCoordinate: center, eyeAltitude: 25000)
        self.mapView.setCamera(camera, animated: false)
        
        mapViewContainer.addSubview(self.mapView)
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.startingHeight = CGFloat(self.mapView.camera.altitude)
        self.positioningTimer = NSTimer(timeInterval: 0.25, target: self, selector: "updateAnnotations", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.positioningTimer, forMode: NSRunLoopCommonModes)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.positioningTimer.invalidate()
        self.positioningTimer = nil
        
        self.checkCoordinate()
    }
    
    var altitude = 0.0
    let multiplier = UIScreen.mainScreen().bounds.height < 700 ? (UIScreen.mainScreen().bounds.height < 600 ? (UIScreen.mainScreen().bounds.height < 500 ? 1.4 : 1.2) : 1) : 0.83
    
    func updateAnnotations() {
        let constant = 0.0004825935724
        let altitude = floor(self.mapView.region.span.latitudeDelta / constant * 100) * multiplier
        print(altitude)
        
        if self.altitude == 0 {
            self.altitude = altitude
            return
        }
        
        var toAdd = Array<PlaceAnnotation>()
        var toRemove = Array<PlaceAnnotation>()
        
        for annotation in self.annotations {
            let visible = Int(altitude) - annotation.place.type.visibility() <= 0
            if let _ = self.mapView.viewForAnnotation(annotation) {
                if !visible {
                    toRemove.append(annotation)
                } else {
                    let northwest = self.mapView.convertPoint(CGPointZero, toCoordinateFromView: self.mapView)
                    let southeast = self.mapView.convertPoint(CGPointMake(self.mapView.frame.width, self.mapView.frame.height), toCoordinateFromView: self.mapView)
                    let inside = (northwest.latitude < annotation.place.latitude && annotation.place.latitude < southeast.latitude || northwest.latitude > annotation.place.latitude && annotation.place.latitude > southeast.latitude)
                        && (northwest.longitude < annotation.place.longitude && annotation.place.longitude < southeast.longitude || northwest.longitude > annotation.place.longitude && annotation.place.longitude > southeast.longitude)
                    
                    if !inside {
                        toRemove.append(annotation)
                    }
                }
            } else {
                if visible {
                    let northwest = self.mapView.convertPoint(CGPointZero, toCoordinateFromView: self.mapView)
                    let southeast = self.mapView.convertPoint(CGPointMake(self.mapView.frame.width, self.mapView.frame.height), toCoordinateFromView: self.mapView)
                    let inside = (northwest.latitude < annotation.place.latitude && annotation.place.latitude < southeast.latitude || northwest.latitude > annotation.place.latitude && annotation.place.latitude > southeast.latitude)
                        && (northwest.longitude < annotation.place.longitude && annotation.place.longitude < southeast.longitude || northwest.longitude > annotation.place.longitude && annotation.place.longitude > southeast.longitude)
                    
                    if inside {
                        toAdd.append(annotation)
                    }
                }
            }
        }
        
        self.mapView.addAnnotations(toAdd)
        
        for annotation in toRemove {
            let annotationView = self.mapView.viewForAnnotation(annotation)!
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                annotationView.alpha = 0
            }, completion: { (animated) -> Void in
                self.mapView.removeAnnotation(annotation)
            })
        }
        
        self.altitude = altitude
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
            
            let camera = MKMapCamera(lookingAtCenterCoordinate: newCoordinate, fromEyeCoordinate: newCoordinate, eyeAltitude: newAltitude)
            self.mapView.setCamera(camera, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for annotationView in views {
            annotationView.alpha = 0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                annotationView.alpha = 1
            })
            
            let tgr = UITapGestureRecognizer(target: self, action: "test")
            annotationView.addGestureRecognizer(tgr)
        }
    }
    
    func test() {
        print("test")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation {
            if annotation is PlaceAnnotation {
                print((annotation as! PlaceAnnotation).place.name)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PlaceAnnotation {
            return (annotation as! PlaceAnnotation).annotationView()
        }
        
        return nil
    }
}
