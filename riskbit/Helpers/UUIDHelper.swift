//
//  UUIDHelper.swift
//  sparkpoll_video
//
//  Created by Alex Murphy on 6/15/17.
//  Copyright © 2017 thexande. All rights reserved.
//

import Foundation
import UIKit

class UUIDHelper {
    static var device_uuid: String {
        get {
            return UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
    }
}
