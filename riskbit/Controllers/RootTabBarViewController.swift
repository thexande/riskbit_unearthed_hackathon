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

class RootTabBarViewController: UITabBarController {
    let tabOneItem: UIViewController = {
        let vc = UINavigationController(rootViewController: ReportsHomeTabViewController())
        let cheersBoardIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.beer, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "reports".uppercased(), image: cheersBoardIcon, selectedImage: cheersBoardIcon)
        vc.tabBarItem = item
        return vc
    }()
    
    let tabTwoItem: UIViewController = {
        let exploreIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.binoculars, color: .black, width: 35, height: 35)
        let vc = UINavigationController(rootViewController: UIViewController())
        let item = UITabBarItem(title: "explore".uppercased(), image: exploreIcon, selectedImage: exploreIcon)
        vc.tabBarItem = item
        return vc
    }()
    
    let tabThreeItem: UIViewController = {
        let myCheersIcon = FontAwesomeHelper.iconToImage(icon: FontAwesome.user, color: .black, width: 35, height: 35)
        let vc = UINavigationController(rootViewController: UIViewController())
        let item = UITabBarItem(title: "my cheers".uppercased(), image: myCheersIcon, selectedImage: myCheersIcon)
        vc.tabBarItem = item
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.backgroundColor = StyleConstants.color.primary_red
        //        self.tabBar.tintColor = .white
        self.viewControllers = [tabOneItem, tabTwoItem, tabThreeItem]
    }
}
