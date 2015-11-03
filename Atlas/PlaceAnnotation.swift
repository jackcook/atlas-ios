//
//  PlaceAnnotation.swift
//  Atlas
//
//  Created by Jack Cook on 11/3/15.
//  Copyright © 2015 Jack Cook. All rights reserved.
//

import MapKit

public class PlaceAnnotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    public var name: String
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
    
    public func annotationView() -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "PlaceAnnotation")
        annotationView.enabled = true
        annotationView.canShowCallout = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Black")
        
        let label = UILabel(frame: CGRectMake(-44, 16, 88, 42))
        label.numberOfLines = 0
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        style.lineSpacing = -3
        
        let textAttributes = [
            NSStrokeColorAttributeName: UIColor.whiteColor(),
            NSForegroundColorAttributeName: UIColor(red: 84.0/255.0, green: 116.0/255.0, blue: 123.0/255.0, alpha: 1.0),
            NSStrokeWidthAttributeName: -6,
            NSFontAttributeName: UIFont.systemFontOfSize(11.5, weight: UIFontWeightHeavy),
            NSKernAttributeName: -0.75,
            NSParagraphStyleAttributeName: style
        ]
        
        label.attributedText = NSAttributedString(string: "Thomas J. Watson Library", attributes: textAttributes)
        label.sizeToFit()
        label.frame = CGRectMake(-label.frame.size.width / 2, 16, label.frame.size.width, label.frame.size.height)
        
        imageView.frame = CGRectMake(-7, 0, 14, 14)
        
        annotationView.addSubview(imageView)
        annotationView.addSubview(label)
        
        return annotationView
    }
}
