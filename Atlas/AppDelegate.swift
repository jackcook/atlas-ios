//
//  AppDelegate.swift
//  Atlas
//
//  Created by Jack Cook on 7/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyA9sa4DaoYLJeoOFBOA7YzAIXdnE578HsE")
        
        return true
    }
}
