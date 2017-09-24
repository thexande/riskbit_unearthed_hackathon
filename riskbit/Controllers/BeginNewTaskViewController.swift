//
//  BeginNewTaskViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import ALCameraViewController

struct FLRAFormCellData {
    let icon_image: UIImage
    let title: String
    let sub_title: String
    let action: ((BeginNewTaskViewController) -> Void)
}

class BeginNewTaskFooterView: UIView {
    let createPhotoButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 75)
        button.setTitle(String.fontAwesomeIcon(name: .camera), for: .normal)
        button.setTitleColor(StyleConstants.light_green, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let createVideoButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 75)
        button.setTitle(String.fontAwesomeIcon(name: .videoCamera), for: .normal)
        button.setTitleColor(StyleConstants.light_green, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [createPhotoButton, createVideoButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        addSubview(stack)
        
        let views_dict: [String:UIView] = ["stack":stack, "label":infoLabel]
        for view in views_dict.values { addSubview(view) }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[stack]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[label]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[stack]-12-[label]-12-|", options: [], metrics: nil, views: views_dict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BeginNewTaskViewController: UITableViewController {
    lazy var footer: BeginNewTaskFooterView = {
        let view = BeginNewTaskFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        view.createVideoButton.addTarget(self, action: #selector(videoButtonClicked), for: .touchUpInside)
        view.createPhotoButton.addTarget(self, action: #selector(videoButtonClicked), for: .touchUpInside)
        return view
    }()
    
    func photoButtonClicked() {
        
    }
    
    func videoButtonClicked() {
        
    }
    
    let task: RealmTask
    init(task: RealmTask) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        title = "Beginning \(task.name)"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cells = [
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .question, color: StyleConstants.light_blue, width: 35, height: 35), title: "What are you doing?", sub_title: self.task.task_description, action: { vc in
//            vc.navigationController?.pushViewController(vc.contactVC, animated: true)
            
        }),
        
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .times, color: StyleConstants.light_blue, width: 35, height: 35), title: "What are the risks?", sub_title: Array(self.task.risks).map({ "-\($0.name)\n" }).joined(), action: { vc in
//            vc.navigationController?.pushViewController(vc.termsVC, animated: true)
            
        }),
        
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .check, color: StyleConstants.light_blue, width: 35, height: 35), title: "What have you done to mitigate?", sub_title: Set(Array(self.task.risks).map({ $0.mitigations }).flatMap({ $0 }).map({ "-\($0.name)\n" })).joined(), action: { vc in
//            vc.navigationController?.pushViewController(vc.privacyVC, animated: true)
        }),
        
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .pencil, color: StyleConstants.light_blue, width: 35, height: 35), title: "Additional Comments", sub_title: "Add additional comments.", action: { vc in
            
        }),
        
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .camera, color: StyleConstants.light_blue, width: 35, height: 35), title: "Add a Photo", sub_title: "Add a photo to this FLRA ticked.", action: { vc in
            let cameraViewController = CameraViewController { [weak self] image, asset in
                // Do something with your image here.
                self?.dismiss(animated: true, completion: nil)
            }
            
            vc.present(cameraViewController, animated: true, completion: nil)
        }),
        
        FLRAFormCellData(icon_image: FontAwesomeHelper.iconToImage(icon: .videoCamera, color: StyleConstants.light_blue, width: 35, height: 35), title: "Add a Video", sub_title: "Add a video to this FLRA ticket", action: { vc in
            
        })
    ]
    
    func cellFactory(with data: FLRAFormCellData) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "account_settings")
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = data.sub_title
        cell.detailTextLabel?.numberOfLines = 0
        cell.imageView?.image = data.icon_image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(with: cells[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells[indexPath.row].action(self)
    }
}
