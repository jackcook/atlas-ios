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
    var type: PlaceType
    
    init(data: JSON) {
        self.id = data["id"].int!
        self.name = data["name"].string!
        self.latitude = data["lat"].double!
        self.longitude = data["lon"].double!
        self.type = PlaceType(rawValue: data["type"].string!)!
    }
    
    func annotation() -> PlaceAnnotation {
        return PlaceAnnotation(place: self)
    }
    
    func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
