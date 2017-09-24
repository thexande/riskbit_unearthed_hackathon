//
//  QueueTabViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FuzzyMatchingSwift


class QueueTabViewController: UIViewController {
    lazy var addTaskToQueueVC: UINavigationController = {
        let vc = AddTaskToQueueViewController(completion: { [weak self] selectedTasks in
            self?.tasks?.append(contentsOf: selectedTasks)
            self?.tableView.reloadData()
            }, currentTasks: self.tasks ?? [])
        return UINavigationController(rootViewController: vc)
    }()
    
    lazy var tasks: [RealmTask]? = {
        do {
            let realm = try Realm()
            guard let tasks = realm.objects(RealmEmployee.self).filter("id = %@", "1234").first?.tasks else { return nil }
            return Array(tasks)
            
        } catch _ { return nil }
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        view.tableFooterView = UIView() 
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        title = "Tasks for \(DateHelper.readableDate(Date()))"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .plus, color: .black, width: 35, height: 35), style: .plain, target: self, action: #selector(pressedAddTask))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    func pressedAddTask() {
        present(addTaskToQueueVC, animated: true, completion: nil)
    }
}

extension QueueTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListViewCell.self)) as? ListViewCell, let tasks = tasks else { return UITableViewCell() }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tasks = tasks else { return }
        navigationController?.pushViewController(UserTaskDetailViewController(tasks[indexPath.row]), animated: true)
    }
}


struct DataConstants {
    static let unNeededWords: [String] = [
        "a","about" ,"all" ,"also" ,"and" ,"as" ,"at" ,"be" ,"because" ,"but" ,"by" ,"can" ,"come" ,"could" ,"day" ,"do" ,"even" ,"find" ,"first" ,"for" ,"from" ,"get" ,"give" ,"go" ,"have" ,"he" ,"her" ,"here" ,"him" ,"his" ,"how" ,"I" ,"if" ,"in" ,"into" ,"it" ,"its" ,"just" ,"know" ,"like" ,"look" ,"make" ,"man" ,"many" ,"me" ,"more" ,"my" ,"new" ,"no" ,"not" ,"now" ,"of" ,"on" ,"one" ,"only" ,"or" ,"other" ,"our" ,"out" ,"people" ,"say" ,"see" ,"she" ,"so" ,"some" ,"take" ,"tell" ,"than" ,"that" ,"the" ,"their" ,"them" ,"then" ,"there" ,"these" ,"they" ,"thing" ,"think" ,"this" ,"those" ,"time" ,"to" ,"two" ,"up" ,"use" ,"very" ,"want" ,"way" ,"we" ,"well" ,"what" ,"when" ,"which" ,"who" ,"will" ,"with" ,"would" ,"year" ,"you" ,"your"
    ]
}
