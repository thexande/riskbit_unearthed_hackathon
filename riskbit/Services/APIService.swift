//
//  APIService.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import PromiseKit
import SwiftyJSON

class APIService {
    static func fetchEmployeesJSON() -> Promise<JSON> {
        let url = URL(string:"http://ec2-54-201-167-124.us-west-2.compute.amazonaws.com:8080/employee/1234")!
        return Promise { resolve, reject in
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { response in
                let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: nil)
                guard let json = response.result.value else { reject(error); return }
                resolve(json)
            }
        }
    }
    
    static func fetchAllTasks() -> Promise<JSON> {
        let url = URL(string:"http://ec2-54-201-167-124.us-west-2.compute.amazonaws.com:8080/tasks")!
        return Promise { resolve, reject in
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { response in
                let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: nil)
                guard let json = response.result.value else { reject(error); return }
                resolve(json)
            }
        }
    }
}
