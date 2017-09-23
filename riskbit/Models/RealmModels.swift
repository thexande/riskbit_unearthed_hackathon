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
    var id = ""
    var name = ""
    var position_name = ""
    var location_name = ""
    var team_name = ""
    var tasks = List<RealmTask>()
}

class RealmTask: Object {
    var id = ""
    var name = ""
    var task_description = ""
    var risks = List<RealmRisk>()
}

class RealmRisk: Object {
    var id = ""
    var name = ""
    var risk_description = ""
    var mitigations = List<RealmMitigation>()
}

class RealmMitigation: Object {
    var id = ""
    var name = ""
    var mitigation_description = ""
}
