//
//  MappingModels.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation

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
