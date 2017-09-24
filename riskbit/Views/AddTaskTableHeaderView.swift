//
//  AddTaskTableHeaderView.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class AddTaskTableHeaderView: UIView {
    lazy var createNewRecordButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9
        button.backgroundColor = StyleConstants.light_green
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Create A New Task", for: .normal)
        //        button.setImage(FontAwesomeHelper.iconToImage(icon: .search, color: .white, width: 35, height: 35).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createNewRecord), for: .touchUpInside)
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 9
        button.backgroundColor = .clear
        button.layer.borderColor = StyleConstants.purple.cgColor
        button.layer.borderWidth = 3
        button.setTitleColor(StyleConstants.purple, for: .normal)
        button.setTitle("Search For Task", for: .normal)
        //        button.setImage(FontAwesomeHelper.iconToImage(icon: .search, color: StyleConstants.purple, width: 35, height: 35).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedSearch), for: .touchUpInside)
        return button
    }()
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Search for a worksite task, or create a new one."
        label.numberOfLines = 0
        return label
    }()
    
    let customSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Select tasks below to add them to your queue."
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var stack: UIStackView  = {
        let stack = UIStackView(arrangedSubviews: [self.customTitleLabel, self.createNewRecordButton, self.searchButton, self.customSubTitleLabel,])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    func selectedSearch() {
        
    }
    
    func createNewRecord() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[stack]-12-|", options: [], metrics: nil, views: ["stack":stack]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[stack]-12-|", options: [], metrics: nil, views: ["stack":stack]))
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: createNewRecordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
