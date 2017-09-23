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
    let id = ""
    let name = ""
    let position_name = ""
    let location_name = ""
    let team_name = ""
    let tasks = List<RealmTask>()
}

class RealmTask: Object {
    let id = ""
    let name = ""
    let task_description = ""
    let risks = List<RealmRisk>()
}

class RealmRisk: Object {
    let id = ""
    let name = ""
    let risk_description = ""
    let mitigations = List<RealmMitigation>()
}

class RealmMitigation: Object {
    let id = ""
    let name = ""
    let mitigation_description = ""
}
