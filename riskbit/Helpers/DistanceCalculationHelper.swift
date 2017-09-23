//
//  DistanceCalculationHelper.swift
//  sparkpoll
//
//  Created by Alexander Murphy on 11/26/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import Foundation
import CoreLocation

class DistanceCalculationHelper {
    static func calculateDistanceBetweenTwoPoints(point_1: CLLocation, point_2: CLLocation)
        -> Int {
            return Int(point_1.distance(from: point_2))
    }
    static func isPollWithinRange(pollRange: Int, clientDistanceFromPoll: Int) -> Bool {
        return clientDistanceFromPoll < pollRange
    }
}
