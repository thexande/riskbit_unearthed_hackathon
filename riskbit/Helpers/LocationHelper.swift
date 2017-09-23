//
//  File.swift
//  sparkpoll
//
//  Created by Alexander Murphy on 11/26/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

class LocationHelper {
    static let sharedInstance = LocationHelper()
    var currentLocation: CLLocation?
    
    init() {
        self.currentLocation = nil
        self.startLocationWatch()
    }
    
    func startLocationWatch() {
        var r = Location.getLocation(withAccuracy: .city, frequency: .continuous, timeout: nil, onSuccess: { (loc) in
            LocationHelper.sharedInstance.currentLocation = loc
            
            // set geoaddress singleton
            GeoLocaitonHelper.sharedInstance.getAdress(completion: { (address) in
                GeoLocaitonHelper.sharedInstance.address = address
            })
            
//            print("loc \(LocationHelper.sharedInstance.currentLocation)")
        }) { (last, err) in
//            print("err \(err)")
        }
        r.onAuthorizationDidChange = { newStatus in
//            print("New status Location \(newStatus)")
        }
    }
    
    public func getCurrentLocation() -> CLLocation? {
        if(self.currentLocation == nil){
            //print("current location is nil")
            return nil
        } else {
            return LocationHelper.sharedInstance.currentLocation!
        }
    }
    public func currentLatitude() -> Double {
        return Double(LocationHelper.sharedInstance.currentLocation?.coordinate.latitude ?? 0)
    }
    public func currentLongitude() -> Double {
        return Double(LocationHelper.sharedInstance.currentLocation?.coordinate.longitude ?? 0)
    }
}
