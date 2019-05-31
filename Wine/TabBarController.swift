//
//  TabBarController.swift
//  Wine
//
//  Created by toxa on 4/30/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().tintColor = UIColor.hex("#FB6D5B")
        let attributes = [ NSAttributedString.Key.font:UIFont(name: "SFProText-Regular", size: 10) ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        customiseTabItems()
    }
    

    
    func customiseTabItems() {
        guard let items = self.tabBar.items  else {
            return
        }
        for (index, item) in items.enumerated() {
            switch index {
            case 0:
                item.image = UIImage(named: "calendarIcon")
                item.title = "Calendar".localized()
                break
            case 1:
                item.image = UIImage(named: "statisticIcon")
                item.title = "Statistics".localized()
                break
            case 2:
                item.image = UIImage(named: "settingsIcon")
                item.title = "Settings".localized()
                break
                default :
                    break
            }
        }
    }
    

}
