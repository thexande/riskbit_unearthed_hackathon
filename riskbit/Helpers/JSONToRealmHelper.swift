//
//  JSONToRealmHelper.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

class JSONToRealmHelper {
    static let guardError = NSError(domain: "", code: 0, userInfo: nil)
    static func fetchAndProcessEmployees() {
        _ = firstly {
            APIService.fetchEmployeesJSON()
            }.then { json -> Void in
                guard let employee_array = json.array else { throw guardError }
                guard let employees = processEmployeesJSON(employee_array) else { throw guardError }
                let tasks = employees.map({ $0.tasks }).flatMap({ $0 })
                let risks = tasks.map({ $0.risks }).flatMap({ $0 })
                let mitigations = risks.map({ $0.mitigations }).flatMap({ $0 })
                
                RealmCRUDHelper.writeEmployees(employees)
                RealmCRUDHelper.writeTasks(tasks)
                RealmCRUDHelper.writeRisks(risks)
                RealmCRUDHelper.writeMitigations(mitigations)
                
                for employee in employees {
                    RealmAssociationHelper.associateTasksWithEmployee(tasks: employee.tasks, employee: employee)
                    for task in employee.tasks {
                        RealmAssociationHelper.associateRisksWithTask(risks: task.risks, task: task)
                        for risk in task.risks {
                            RealmAssociationHelper.associateMitigationsWithRisk(mitigations: risk.mitigations, risk: risk)
                        }
                    }
                }
                
                print("loaded \(employees.count) employee from API")
        }
    }
    
    static func fetchAllTasks() {
        _ = firstly {
            APIService.fetchAllTasks()
        }.then { json -> Void in
            guard let json = json.array, let tasks = processTasksJSON(json) else { throw guardError }
            let risks = tasks.map({ $0.risks }).flatMap({ $0 })
            let mitigations = risks.map({ $0.mitigations }).flatMap({ $0 })
            
            RealmCRUDHelper.writeTasks(tasks)
            RealmCRUDHelper.writeRisks(risks)
            RealmCRUDHelper.writeMitigations(mitigations)
            
            for task in tasks {
                RealmAssociationHelper.associateRisksWithTask(risks: task.risks, task: task)
                for risk in task.risks {
                    RealmAssociationHelper.associateMitigationsWithRisk(mitigations: risk.mitigations, risk: risk)
                }
            }
            print("loaded \(tasks.count) tasks from API")
        }
    }
    
    static func processEmployeesJSON(_ employees: [JSON]) -> [Employee]? {
        var returnEmployees = [Employee]()
        for employee in employees {
            guard let id = employee.dictionary?["employeeid"]?.stringValue,
                let position = employee.dictionary?["positionname"]?.stringValue,
                let location = employee.dictionary?["locationname"]?.stringValue else { return nil }
            let tasks = employee.dictionary?["tasks"]?.array ?? []
            guard let taskModels = processTasksJSON(tasks) else { return nil }
            let employeeModel = Employee(id: id, position_name: position, location_name: location, tasks: taskModels)
            returnEmployees.append(employeeModel)
        }
        return returnEmployees
    }
    
    static func processTasksJSON(_ tasks: [JSON]) -> [Task]? {
        var returnTasks = [Task]()
        for task in tasks {
            guard let id = task.dictionary?["taskid"]?.stringValue,
                let name = task.dictionary?["taskname"]?.stringValue,
                let description = task.dictionary?["taskdesc"]?.stringValue else { return nil }
            
            let risks = task.dictionary?["risks"]?.array ?? []
            guard let riskModels = processRisksJSON(risks) else { return nil }
            let taskIntermediate = Task(id: id, name: name, description: description, risks: riskModels)
            returnTasks.append(taskIntermediate)
        }
        return returnTasks
    }
    
    static func processRisksJSON(_ risks: [JSON]) -> [Risk]? {
        var returnRisks = [Risk]()
        
        for risk in risks {
            guard let id = risk.dictionary?["riskid"]?.stringValue,
                let description = risk.dictionary?["riskdesc"]?.stringValue,
                let name = risk.dictionary?["riskname"]?.stringValue else { return nil }
            let mitigations = risk.dictionary?["mitigations"]?.array ?? []
            guard let mitigationModels = processMitigationsJSON(mitigations) else { return nil }
            let riskModel = Risk(id: id, name: name, description: description, mitigations: mitigationModels)
            returnRisks.append(riskModel)
        }
        return returnRisks
    }
    
    static func processMitigationsJSON(_ mitigations: [JSON]) -> [Mitigation]? {
        var returnMitigations = [Mitigation]()
        for mitigation in mitigations {
            guard let id = mitigation.dictionary?["mitigationid"]?.stringValue,
                let description = mitigation.dictionary?["mitigationdesc"]?.stringValue,
                let name = mitigation.dictionary?["mitigationname"]?.stringValue else { return nil }
            let mitigationModel = Mitigation(id: id, name: name, description: description)
            returnMitigations.append(mitigationModel)
        }
        return returnMitigations
    }
}
