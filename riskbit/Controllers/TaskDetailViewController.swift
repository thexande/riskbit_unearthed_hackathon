//
//  TaskDetailViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class TaskDetailRiskHeaderView: UITableViewHeaderFooterView {
    let bubbleWidth: CGFloat = 30
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat(self.bubbleWidth / 2)
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.bubbleLabel)
        return view
    }()
    
    let bubbleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "T"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let customSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let views_dict: [String:UIView] = ["title":customTitleLabel, "subtitle":customSubTitleLabel, "bubble":bubbleView]
        
        for view in views_dict.values {
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bubbleWidth),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bubbleWidth),
            NSLayoutConstraint(item: bubbleLabel, attribute: .centerX, relatedBy: .equal, toItem: bubbleView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleLabel, attribute: .centerY, relatedBy: .equal, toItem: bubbleView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12)
            ])
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[title]-12-[subtitle]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[bubble]-12-[title]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[bubble]-12-[subtitle]-12-|", options: [], metrics: nil, views: views_dict))
        
    }
    
    func setRisk(_ risk: RealmRisk) {
        bubbleView.backgroundColor = .red
        bubbleLabel.text = "R"
        customTitleLabel.text = risk.name
        customSubTitleLabel.text = risk.risk_description
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TaskDetailViewController: UITableViewController {
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
        title = task.name
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        tableView.register(TaskDetailRiskHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self))
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
