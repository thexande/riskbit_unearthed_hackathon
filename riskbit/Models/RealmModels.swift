//
//  Employee.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmEmployee: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var position_name = ""
    dynamic var location_name = ""
    dynamic var team_name = ""
    var tasks = List<RealmTask>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmTask: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var task_description = ""
    var risks = List<RealmRisk>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmRisk: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var risk_description = ""
    var mitigations = List<RealmMitigation>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmMitigation: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var mitigation_description = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
