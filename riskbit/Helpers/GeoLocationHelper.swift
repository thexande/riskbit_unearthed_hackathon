//
//  GeoLocationHelper.swift
//  sparkpoll
//
//  Created by Alex Murphy on 1/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import MapKit

struct Typealiases {
    typealias JSONDict = [String:Any]
}

class GeoLocaitonHelper {
    let locManager = CLLocationManager()
    var address: GeoAddress?
    static let sharedInstance = GeoLocaitonHelper()
    var currentLocation: CLLocation?
    
    func getAdress(completion: @escaping (GeoAddress?) -> ()) {
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = LocationHelper.sharedInstance.currentLocation
            let geoCoder = CLGeocoder()
            guard let currentLocation = self.currentLocation else {
                completion(nil)
                return
            }
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                if error != nil {
//                    print("Error getting location: \(error?.localizedDescription ?? "")")
                } else {
                    guard let placeArray = placemarks else {
                        completion(nil)
                        return
                    }
                    let placeMark = placeArray[0]
                    guard var address = placeMark.addressDictionary as? Typealiases.JSONDict else {
                        completion(nil)
                        return
                    }
                    address["city_name"] = placeMark.locality
                    guard let formatted_address = placeMark.addressDictionary?["FormattedAddressLines"] as? [String] else {
                        completion(nil)
                        return
                    }
                    
                    address["formatted_address"] = formatted_address.joined(separator: ", ")
                    completion(GeoAddress(address))
                }
            }
        }
    }
}
