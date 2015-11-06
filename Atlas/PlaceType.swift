//
//  PlaceType.swift
//  Atlas
//
//  Created by Jack Cook on 11/4/15.
//  Copyright © 2015 Jack Cook. All rights reserved.
//

import UIKit

public enum PlaceType: String {
    case Citibike = "citibike"
    case Monument = "monument"
    case Museum = "museum"
    
    func color() -> UIColor {
        switch self {
        case .Citibike:
            return UIColor(red: 0.08, green: 0.2, blue: 0.44, alpha: 1.0)
        case .Museum:
            return UIColor(red: 0.45, green: 0.53, blue: 0.71, alpha: 1.0)
        case .Monument:
            return UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)
        }
    }
    
    func image() -> UIImage {
        return UIImage(named: self.rawValue) != nil ? UIImage(named: self.rawValue)! : UIImage(named: "museum")!
    }
    
    func visibility() -> Int {
        switch self {
        case .Citibike:
            return 1500
        case .Museum:
            return 13000
        case .Monument:
            return 30000
        }
    }
}
