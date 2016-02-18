//
//  HBMainTabBar.swift
//  HealthyBoy
//
//  Created by jszx on 16/2/18.
//  Copyright © 2016年 jszx. All rights reserved.
//


class HBMainTabBarController: UITabBarController {
    override func viewDidLoad() {
        self.selectedIndex = 1
//        self.selectedIndex = 0
    }
    override func viewDidAppear(animated: Bool) {
//        self.selectedIndex = 1
        self.selectedIndex = 0
    }

}
