//
//  UserTaskDetailViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class UserTaskDetailTableHeader: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserTaskDetailViewController: UITableViewController {
    let task: RealmTask
    lazy var risks: [RealmRisk] = Array(self.task.risks)
    lazy var mitigationTuples: [(RealmRisk, Set<RealmMitigation>)] = {
        return self.risks.map({ (risk) -> (RealmRisk, Set<RealmMitigation>) in
            return (risk, Set(risk.mitigations))
        })
    }()
    
    init(_ task: RealmTask) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        title = task.name
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        tableView.register(TaskDetailRiskHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self))
        tableView.tableHeaderView = UserTaskDetailTableHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListViewCell.self)) as? ListViewCell else { return UITableViewCell() }
        cell.setMitigation(mitigationTuples.map({ $0.1 }).flatMap({ $0 })[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self)) as? TaskDetailRiskHeaderView else { return UITableViewHeaderFooterView() }
        header.setRisk(mitigationTuples[section].0)
        return header
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mitigationTuples.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mitigationTuples.map({ $0.1.count }).reduce(0, { $0 + $1 })
    }
}

