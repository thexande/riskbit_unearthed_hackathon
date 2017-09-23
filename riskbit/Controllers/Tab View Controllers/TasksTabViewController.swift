//
//  TasksHomeTabViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/22/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TasksTabViewController: UIViewController {
    lazy var tasks: Results<RealmTask>? = {
        do {
            let realm = try Realm()
            return realm.objects(RealmTask.self)
            
        } catch _ { return nil }
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.register(TaskTableCell.self, forCellReuseIdentifier: NSStringFromClass(TaskTableCell.self))
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let views_dict: [String:UIView] = ["table":tableView]
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[table]|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: views_dict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .plus, color: .black, width: 35, height: 35).withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(pressedNew))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func pressedNew() {
        
    }
}

extension TasksTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TaskTableCell.self)) as? TaskTableCell, let tasks = tasks else { return UITableViewCell() }
        cell.setTask(tasks[indexPath.row])
        let task = tasks[indexPath.row]
        print(task.name)
        cell.customTitleLabel.text = task.name
        cell.customSubTitleLabel.text = task.task_description
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else { return 0 }
        return tasks.count
    }
}
