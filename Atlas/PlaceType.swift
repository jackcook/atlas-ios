//
//  PlaceType.swift
//  Atlas
//
//  Created by Jack Cook on 11/4/15.
//  Copyright © 2015 Jack Cook. All rights reserved.
//

public enum PlaceType: String {
    case Monument = "monument"
    case Museum = "museum"
    
    func visibility() -> Int {
        switch self.rawValue {
        case "museum":
            return 13000
        case "monument":
            return 30000
        default:
            return 10000
        }
    }
}
