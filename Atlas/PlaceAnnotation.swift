//
//  PlaceAnnotation.swift
//  Atlas
//
//  Created by Jack Cook on 11/3/15.
//  Copyright © 2015 Jack Cook. All rights reserved.
//

import HexColors
import MapKit
import THLabel

public class PlaceAnnotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    public var place: Place
    
    init(place: Place) {
        self.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude)
        self.place = place
    }
    
    public func annotationView() -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "PlaceAnnotation")
        annotationView.enabled = true
        annotationView.canShowCallout = false
        annotationView.frame = CGRectMake(0, 0, 88, 60)
        
        annotationView.centerOffset = CGPointMake(0, 22)
        
        let imageView = UIImageView(frame: CGRectMake(36, 0, 16, 16))
        imageView.image = self.place.type.image()
        
        let label = THLabel(frame: CGRectMake(0, 18, 88, 42))
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        label.text = self.place.name
        label.textAlignment = .Center
        label.textColor = self.place.type.color()
        label.font = UIFont.systemFontOfSize(10.5, weight: UIFontWeightSemibold)
        
        label.letterSpacing = -0.25
        label.strokeColor = UIColor.whiteColor()
        label.strokeSize = 1
        label.contentMode = .Top
        
        annotationView.addSubview(imageView)
        annotationView.addSubview(label)
        
        return annotationView
    }
    
    public func isVisible(mapView: MKMapView) -> Bool {
        let northwest = mapView.convertPoint(CGPointZero, toCoordinateFromView: mapView)
        let southeast = mapView.convertPoint(CGPointMake(mapView.frame.width, mapView.frame.height), toCoordinateFromView: mapView)
        return (northwest.latitude < self.place.latitude && self.place.latitude < southeast.latitude || northwest.latitude > self.place.latitude && self.place.latitude > southeast.latitude)
            && (northwest.longitude < self.place.longitude && self.place.longitude < southeast.longitude || northwest.longitude > self.place.longitude && self.place.longitude > southeast.longitude)
    }
}
