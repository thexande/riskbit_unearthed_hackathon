//
//  BeginNewTaskViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class BeginNewTaskViewController: UITableViewController {
    init(task: RealmTask) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
