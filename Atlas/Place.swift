//
//  Place.swift
//  Atlas
//
//  Created by Jack Cook on 11/3/15.
//  Copyright © 2015 Jack Cook. All rights reserved.
//

import MapKit
import SwiftyJSON

public struct Place {
    
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(data: JSON) {
        self.id = data["id"].int!
        self.name = data["name"].string!
        self.latitude = data["latitude"].double!
        self.longitude = data["longitude"].double!
    }
    
    func annotation() -> PlaceAnnotation {
        return PlaceAnnotation(name: self.name, coordinate: self.coordinate())
    }
    
    func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
