//
//  AddTaskToQueueViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CompletionStatusTagView: UIView {
    func setCompletion(_ completed: Bool) {
        if completed {
            self.backgroundColor = StyleConstants.super_light_green
            statusLabel.text = "completed".uppercased()
        } else {
            self.backgroundColor = StyleConstants.dark_red
            statusLabel.text = "unstarted".uppercased()
        }
    }
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        clipsToBounds = true
        addSubview(statusLabel)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[label]-6-|", options: [], metrics: nil, views: ["label":statusLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[label]-6-|", options: [], metrics: nil, views: ["label":statusLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AddTaskToQueueViewController: UITableViewController {
    let completion: (([RealmTask]) -> Void)
    var tasks: [RealmTask]?
    
    lazy var textToSearchVC: UIViewController = {
        let vc = SpeechToTextSearchViewController(completion: { [weak self] (searchText) in
            print(searchText)
            self?.searchWithText(searchText)
        })
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }()
    
    let header = AddTaskTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
    
    init(completion: @escaping(_ selectedTaskIds: [RealmTask]) -> Void, currentTasks: [RealmTask]) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        title = "Add Tasks to Queue"
        tableView.allowsMultipleSelection = true
        tableView.tableHeaderView = header
        header.searchButton.addTarget(self, action: #selector(pressedSearch), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .times, color: .black, width: 35, height: 35), style: .plain, target: self, action: #selector(pressedClose))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: FontAwesomeHelper.iconToImage(icon: .check, color: .black, width: 35, height: 35), style: .plain, target: self, action: #selector(pressedComplete))
        ]
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ListViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListViewCell.self))
        
        
        do {
            let realm = try Realm()
            tasks = Array(realm.objects(RealmTask.self)).filter({ !currentTasks.contains($0) })
            tableView.reloadData()
            
        } catch _ { return }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressedClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func pressedComplete() {
        guard let tasks = tasks, let selectedIndexes = tableView.indexPathsForSelectedRows else { return }
        let selectedTasks = selectedIndexes.map({ tasks[$0.row] })
        
        let alert = UIAlertController(title: "Preparing to add the following tasks to your queue:\n", message: selectedTasks.map({ $0.name }).joined(separator: "\n"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.dismiss(animated: true, completion: {
                self?.completion(selectedTasks)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListViewCell.self)) as? ListViewCell, let tasks = tasks else { return UITableViewCell() }
        cell.setTask(tasks[indexPath.row])
        let task = tasks[indexPath.row]
        print(task.name)
        cell.customTitleLabel.text = task.name
        cell.customSubTitleLabel.text = task.task_description
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else { return 0 }
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tasks = tasks else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
}

extension AddTaskToQueueViewController {
    
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
