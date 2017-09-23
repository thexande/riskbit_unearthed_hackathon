//
//  TaskTableCell.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class TaskTableCell: UITableViewCell {
    let bubbleWidth: CGFloat = 40
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
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "T"
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
    
    func setTask(_ task: RealmTask) {
        customTitleLabel.text = task.name
        customSubTitleLabel.text = task.task_description
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views_dict: [String:UIView] = ["title":customTitleLabel, "subtitle":customSubTitleLabel, "bubble":bubbleView]
        
        for view in views_dict.values {
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bubbleWidth),
            NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bubbleWidth),
            NSLayoutConstraint(item: bubbleLabel, attribute: .centerX, relatedBy: .equal, toItem: bubbleView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleLabel, attribute: .centerY, relatedBy: .equal, toItem: bubbleView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12)
        ])
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[title]-12-[subtitle]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[bubble]-12-[title]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[bubble]-12-[subtitle]-12-|", options: [], metrics: nil, views: views_dict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
