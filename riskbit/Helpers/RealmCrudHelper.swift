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
                        realm.add(object, update: true)
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
        let realmTasks = tasks.map { (task) -> RealmTask in
            let realmTask = RealmTask()
            realmTask.id = task.id
            realmTask.name = task.name
            realmTask.task_description = task.description
            return realmTask
        }
        addRealmObjects(realmTasks)
    }
    
    static func writeRisks(_ risks: [Risk]) {
        let realmRisks = risks.map { (risk) -> RealmRisk in
            let realmRisk = RealmRisk()
            realmRisk.id = risk.id
            realmRisk.name = risk.name
            realmRisk.risk_description = risk.description
            return realmRisk
        }
        addRealmObjects(realmRisks)
    }
    
    static func writeMitigations(_ mitigations: [Mitigation]) {
        let realmMitigations = mitigations.map { (mitigation) -> RealmMitigation in
            let realmMitigation = RealmMitigation()
            realmMitigation.id = mitigation.id
            realmMitigation.name = mitigation.name
            realmMitigation.mitigation_description = mitigation.description
            return realmMitigation
        }
        addRealmObjects(realmMitigations)
    }
}


class RealmQueryHelper {
    static func getTaskById(_ taskId: String) -> RealmTask? {
        do {
            let realm = try Realm()
            return realm.objects(RealmTask.self).filter(NSPredicate(format: "id = %@", taskId)).first
        } catch _ { return nil }
    }
    
    static func getEmployeeById(_ taskId: String) -> RealmEmployee? {
        do {
            let realm = try Realm()
            return realm.objects(RealmEmployee.self).filter(NSPredicate(format: "id = %@", taskId)).first
        } catch _ { return nil }
    }
    
    static func getRiskById(_ riskId: String) -> RealmRisk? {
        do {
            let realm = try Realm()
            return realm.objects(RealmRisk.self).filter(NSPredicate(format: "id = %@", riskId)).first
        } catch _ { return nil }
    }
    
    static func getMitigationById(_ mitigationId: String) -> RealmMitigation? {
        do {
            let realm = try Realm()
            return realm.objects(RealmMitigation.self).filter(NSPredicate(format: "id = %@", mitigationId)).first
        } catch _ { return nil }
    }
}

class RealmAssociationHelper {
    static func associateTasksWithEmployee(tasks: [Task], employee: Employee) {
        guard let employee = RealmQueryHelper.getEmployeeById(employee.id) else { return }
        do {
            let realm = try Realm()
            try realm.write {
                employee.tasks.append(contentsOf: tasks.map({ RealmQueryHelper.getTaskById($0.id) }).flatMap({ $0 }))
            }
        } catch _ { }
    }
    
    static func associateRisksWithTask(risks: [Risk], task: Task) {
        guard let task = RealmQueryHelper.getTaskById(task.id) else { return }
        do {
            let realm = try Realm()
            try realm.write {
                task.risks.append(contentsOf: risks.map({ RealmQueryHelper.getRiskById($0.id) }).flatMap({ $0 }))
            }
        } catch _ { }
    }
    
    static func associateMitigationsWithRisk(mitigations: [Mitigation], risk: Risk) {
        guard let risk = RealmQueryHelper.getRiskById(risk.id) else { return }
        do {
            let realm = try Realm()
            try realm.write {
                risk.mitigations.append(contentsOf: mitigations.map({ RealmQueryHelper.getMitigationById($0.id) }).flatMap({ $0 }))
            }
        } catch _ { }
    }
}
