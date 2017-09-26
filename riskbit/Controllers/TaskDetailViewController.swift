//
//  TaskDetailViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var task: RealmTask? {
        didSet {
            title = task?.name
            guard let tasks = self.task?.risks else { return }
            let arr = Array(tasks)
            risks = arr
            mitigationTuples = mitigationTuplesFunc()
            tableView.reloadData()
        }
    }
    
    lazy var risks: [RealmRisk] = {
        guard let tasks = self.task?.risks else { return [] }
        let arr = Array(tasks)
        return arr
    }()
    
    var mitigationTuples = [(RealmRisk, Set<RealmMitigation>)]()
    
    func mitigationTuplesFunc() -> [(RealmRisk, Set<RealmMitigation>)] {
        return self.risks.map({ (risk) -> (RealmRisk, Set<RealmMitigation>) in
            return (risk, Set(risk.mitigations))
        })
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableViewAutomaticDimension
        view.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        view.register(TaskDetailRiskHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self))
        view.tableFooterView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    
        view.addSubview(tableView)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: ["table":tableView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: ["table":tableView]))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListViewCell.self)) as? ListViewCell else { return UITableViewCell() }
        cell.setMitigation(mitigationTuples.map({ $0.1 }).flatMap({ $0 })[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self)) as? TaskDetailRiskHeaderView else { return UITableViewHeaderFooterView() }
        header.setRisk(mitigationTuples[section].0)
        return header
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return mitigationTuples.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mitigationTuples.map({ $0.1.count }).reduce(0, { $0 + $1 })
    }
}
