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
    lazy var textToSearchVC: UIViewController = {
        let vc = SpeechToTextSearchViewController(completion: { [weak self] (searchText) in
            print(searchText)
            self?.searchWithText(searchText)
        })
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }()
    
    lazy var tasks: [RealmTask]? = {
        do {
            let realm = try Realm()
            return Array(realm.objects(RealmTask.self))
            
        } catch _ { return nil }
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
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
        title = "Site Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .plus, color: .black, width: 35, height: 35), style: .plain, target: self, action: #selector(pressedNew))
    
    
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .search, color: .black, width: 35, height: 35), style: .plain, target: self, action: #selector(pressedSearch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func pressedNew() {
        
    }
}

extension TasksTabViewController {
    
    func produceTaskArray(_ task: RealmTask) -> [String] {
        var descriptionArr = task.task_description.lowercased().components(separatedBy: " ")
        descriptionArr.append(contentsOf: task.name.lowercased().components(separatedBy: " "))
        return descriptionArr
    }
    
    
    func pressedSearch() {
        present(textToSearchVC, animated: true, completion: nil)
    }
    
    func removeCommonWordsFromSearch(_ searchText: String)  -> Set<String> {
        return Set(searchText.components(separatedBy: " ").filter({ !DataConstants.unNeededWords.contains($0) }))
    }
    
    func searchWithText(_ searchText: String) {
        do {
            let realm = try Realm()
            let tasks = realm.objects(RealmTask.self).filter( { [weak self] (task) -> Bool in
                guard let strongSelf = self else { return false }
                let descriptionArr = strongSelf.produceTaskArray(task)
                
                let descriptionSet = Set(descriptionArr)
                let searchSet = strongSelf.removeCommonWordsFromSearch(searchText)
                
                let occurances = descriptionSet.union(searchSet).count
                return occurances != 0
            }).sorted(by: { (task_one, task_two) -> Bool in
                let searchSet = Set(searchText.components(separatedBy: " "))
                let taskOneDescriptionSet = Set(produceTaskArray(task_one))
                let taskTwoDescriptionSet = Set(produceTaskArray(task_two))
                
                let one_occurances = taskOneDescriptionSet.intersection(searchSet).count
                let two_occurances = taskTwoDescriptionSet.intersection(searchSet).count
                
                return one_occurances > two_occurances
            })
            
            self.tasks = tasks
            tableView.reloadData()
            
            print(tasks.count)
        } catch _ { return }
    }
}

extension TasksTabViewController: UITableViewDelegate, UITableViewDataSource {
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
        navigationController?.pushViewController(TaskDetailViewController(tasks[indexPath.row]), animated: true)
    }
}
