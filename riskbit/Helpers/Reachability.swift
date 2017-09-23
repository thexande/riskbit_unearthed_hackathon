//
//  Reachability.swift
//  cheers_around_the_world
//
//  Created by Alexander Murphy on 8/10/17.
//  Copyright © 2017 thexande. All rights reserved.
//

import SystemConfiguration
import Foundation

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    
    
    class func isInternetAvailable(webSiteToPing: String?, completionHandler: @escaping (Bool) -> Void) {
        
        // 1. Check the WiFi Connection
        guard isConnectedToNetwork() else {
            completionHandler(false)
            return
        }
        
        // 2. Check the Internet Connection
        var webAddress = "https://www.google.com" // Default Web Site
        if let _ = webSiteToPing {
            webAddress = webSiteToPing!
        }
        
        guard let url = URL(string: webAddress) else {
            completionHandler(false)
            print("could not create url from: \(webAddress)")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil || response == nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
        
        task.resume()
    }
}
