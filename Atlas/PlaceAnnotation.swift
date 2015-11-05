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
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Black")
        
        let label = THLabel(frame: CGRectMake(-44, 16, 88, 42))
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        label.text = self.place.name
        label.textAlignment = .Center
        label.textColor = UIColor.hx_colorWithHexString("#879DCC")
        label.font = UIFont.systemFontOfSize(11, weight: UIFontWeightBold)
        
        label.letterSpacing = -0.75
        label.strokeColor = UIColor.whiteColor()
        label.strokeSize = 1
        label.contentMode = .Top
        
        imageView.frame = CGRectMake(-7, 0, 14, 14)
        
        annotationView.addSubview(imageView)
        annotationView.addSubview(label)
        
        return annotationView
    }
}
