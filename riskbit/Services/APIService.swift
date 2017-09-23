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
        let url = URL(string:"http://10.2.4.161:8080/employee/1234")!
        return Promise { resolve, reject in
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { response in
                let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: nil)
                guard let json = response.result.value else { reject(error); return }
                resolve(json)
            }
        }
    }
}

struct Employee {
    let id: String
    let position_name: String
    let location_name: String
    let tasks: [Task]
}

struct Task {
    let id: String
    let name: String
    let description: String
    let risks: [Risk]
}

struct Risk {
    let id: String
    let name: String
    let description: String
    let mitigations : [Mitigation]
}

struct Mitigation {
    let id: String
    let name: String
    let description: String
}


