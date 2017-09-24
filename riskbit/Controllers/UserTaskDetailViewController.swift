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
    
    lazy var beginTaskButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9
        button.backgroundColor = StyleConstants.light_green
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Begin Task", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(beginTaskButton)
        addSubview(descriptionLabel)
        let views_dict: [String:UIView] = ["description":descriptionLabel, "task_button":beginTaskButton]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[description]-12-[task_button(40)]", options: [], metrics: nil, views:views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[task_button]-12-|", options: [], metrics: nil, views:views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[description]-12-|", options: [], metrics: nil, views:views_dict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserTaskDetailViewController: UITableViewController {
    let task: RealmTask
    lazy var tableHeaderView:UserTaskDetailTableHeader = {
        let height = UILabel.height(for: self.task.task_description, width: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 13))
        let view_height: CGFloat = 12 + 40 + 12 + height + 12
        let view = UserTaskDetailTableHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view_height))
        return view
    }()
    
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
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        tableView.register(TaskDetailRiskHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(TaskDetailRiskHeaderView.self))
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.beginTaskButton.addTarget(self, action: #selector(beginTask), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginTask() {
        print("count here: \(tableView.indexPathsForSelectedRows?.count ?? 0)")
        if tableView.indexPathsForSelectedRows?.count ?? 0 < 5 {
            let beginTaskAlertController: UIAlertController = {
                let controller = UIAlertController(title: "Mitigation Review for \(self.task.name)", message: "Please select a minimum of 5 mitigations you plan on implementing for \(self.task.name). Only \(tableView.indexPathsForSelectedRows?.count ?? 0) have been selected.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    
                }))
                return controller
            }()
            
            self.present(beginTaskAlertController, animated: true, completion: nil)
        } else {
            let selectedMitigations = mitigationTuples.map({ $0.1 }).flatMap({ $0 }).enumerated().map({ [weak self] (index, mitigation) -> String? in
                guard let selected = self?.tableView.indexPathsForSelectedRows?.map({ $0.row }) else { return nil }
                print("\(selected), index: \(index)")
                if selected.contains(index) {
                    return "\(mitigation.name)"
                } else { return nil }
            }).flatMap({ $0 })
            
            let alert = UIAlertController(title: "Preparing to begin \(self.task.name)", message: "you have selected \(tableView.indexPathsForSelectedRows?.count ?? 0) mitigations:\n \(selectedMitigations.joined(separator: "\n"))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.pushViewController(BeginNewTaskViewController(task: strongSelf.task), animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
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
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
}

