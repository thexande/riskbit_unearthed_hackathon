//
//  LeaderboardTabViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/23/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

struct Miner {
    let name: String
    let image: UIImage
    let upvotes: Int
}

class LeaderboardTabViewController: UITableViewController {
    let miners = [
        Miner(name: "Stimpy Dangerfield", image: #imageLiteral(resourceName: "miner_1"), upvotes: 44),
        Miner(name: "Chuck Harris", image: #imageLiteral(resourceName: "miner_2"), upvotes: 24),
        Miner(name: "Doug Dimmadome", image: #imageLiteral(resourceName: "miner_3"), upvotes: 41),
        Miner(name: "Dink McGuillicudy", image: #imageLiteral(resourceName: "miner_4"), upvotes: 33),
        Miner(name: "Miner Jones", image: #imageLiteral(resourceName: "miner_5"), upvotes: 2)
    ]
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Miner Leaderboard"
        tableView.tableFooterView = UIView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "woot")
        let miner = miners[indexPath.row]
        cell.imageView?.image = miner.image
        cell.detailTextLabel?.text = "\(miner.upvotes) Solid Recomendations"
        cell.detailTextLabel?.textColor = StyleConstants.light_blue
        cell.textLabel?.text = miner.name
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 40
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
