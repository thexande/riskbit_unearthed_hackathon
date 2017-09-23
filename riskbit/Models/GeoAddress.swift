//
//  GeoAddress.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/22/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation

class GeoAddress {
    let street: String
    let zip_code: String
    let country: String
    let sub_thoroughfare: String
    let state_code: String
    let city_name: String
    let sub_administrative_area: String
    let thoroughfare: String
    let formatted_address: String
    let address_id: String
//    let ref: DatabaseReference?
    
    init(_ dict: [String: Any]) {
//        self.ref = nil
        street = dict["Street"] as! String
        zip_code = dict["ZIP"] as! String
        country = dict["Country"] as! String
        formatted_address = dict["formatted_address"] as! String
        sub_thoroughfare = dict["SubThoroughfare"] as? String ?? ""
        state_code = dict["State"] as? String ?? ""
        city_name = dict["city_name"] as? String ?? ""
        sub_administrative_area = dict["SubAdministrativeArea"] as? String ?? ""
        thoroughfare = dict["Thoroughfare"] as? String ?? ""
        address_id = "String.random(length: 16)"
    }
    
//    init(_ snap: DataSnapshot) {
//        self.ref = snap.ref
//        let snapValue = snap.value as! [String: AnyObject]
//        street = snapValue["street"] as! String
//        zip_code = snapValue["zip_code"] as! String
//        country = snapValue["country"] as! String
//        sub_thoroughfare = snapValue["sub_thoroughfare"] as! String
//        state_code = snapValue["state_code"] as! String
//        city_name = snapValue["city_name"] as! String
//        formatted_address = snapValue["formatted_address"] as! String
//        sub_administrative_area = snapValue["sub_administrative_area"] as! String
//        thoroughfare = snapValue["throughfare"] as! String
//        address_id = snap.key
//    }
//
    func toAnyObject() -> Any {
        return [
            "street": street,
            "zip_code": zip_code,
            "country": country,
            "sub_throughfare": sub_thoroughfare,
            "state_code": state_code,
            "city_name": city_name,
            "sub_administrative_area": sub_administrative_area,
            "thoroughfare": thoroughfare,
            "formatted_address": formatted_address,
            "address_id": address_id
        ]
    }
}
