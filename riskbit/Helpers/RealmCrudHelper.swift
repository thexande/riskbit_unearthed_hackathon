//
//  RealmCrudHelper.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmCRUDHelper {
    static func addRealmObjects(_ objects: [Object]) {
        do {
            let realm = try Realm()
            for object in objects {
                do {
                    try realm.write {
                        realm.add(object)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func writeEmployees(_ employees: [Employee]) {
        let realmEmployees = employees.map { (employee) -> RealmEmployee in
            let realmEmployee = RealmEmployee()
            realmEmployee.id = employee.id
            realmEmployee.location_name = employee.location_name
            realmEmployee.name = employee.location_name
            return realmEmployee
        }
        
        addRealmObjects(realmEmployees)
    }
    
    static func writeTasks(_ tasks: [Task]) {
        
    }
    
    static func writeRisks(_ risks: [Risk]) {
        
    }
    
    static func writeMitigations(_ mitigations: [Mitigation]) {
        
    }
}


class RealmAssociationHelper {
    
}
