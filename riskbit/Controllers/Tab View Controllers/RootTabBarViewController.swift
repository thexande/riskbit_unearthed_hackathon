//
//  RootTabBarViewController.swift
//  riskbit
//
//  Created by Alexander Murphy on 9/22/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import RealmSwift

class RootTabBarViewController: UITabBarController {
    let tabOneItem: UIViewController = {
        let vc = UINavigationController(rootViewController: QueueTabViewController())
        let cheersBoardIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.list, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "queue".uppercased(), image: cheersBoardIcon, selectedImage: cheersBoardIcon)
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.tabBarItem = item
        return vc
    }()
    
    let tabTwoItem: UIViewController = {
        let vc = UINavigationController(rootViewController: TasksTabViewController())
        let cheersBoardIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.check, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "tasks".uppercased(), image: cheersBoardIcon, selectedImage: cheersBoardIcon)
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.tabBarItem = item
        return vc
    }()
    
    let tabThreeItem: UIViewController = {
        let exploreIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.trophy, color: .black, width: 35, height: 35)
        let vc = UINavigationController(rootViewController: LeaderboardTabViewController())
        let item = UITabBarItem(title: "leaderboard".uppercased(), image: exploreIcon, selectedImage: exploreIcon)
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.tabBarItem = item
        return vc
    }()
    
    let tabFourItem: UIViewController = {
        let myCheersIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.user, color: .black, width: 35, height: 35)
        let vc = UINavigationController(rootViewController: UIViewController())
        let item = UITabBarItem(title: "account".uppercased(), image: myCheersIcon, selectedImage: myCheersIcon)
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.tabBarItem = item
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.backgroundColor = StyleConstants.color.primary_red
        //        self.tabBar.tintColor = .white
        self.viewControllers = [tabOneItem, tabTwoItem, tabThreeItem, tabFourItem]
        
        do {
            let realm = try Realm()
            debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
        } catch let error {
            print(error.localizedDescription)
        }
        
        JSONToRealmHelper.fetchAndProcessEmployees()
    }
}
