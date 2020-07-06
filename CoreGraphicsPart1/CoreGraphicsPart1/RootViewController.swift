//
//  RootViewController.swift
//  CoreGraphicsPart1
//
//  Created by Pham Quang Huy on 4/13/17.
//  Copyright © 2017 Framgia, Inc. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewController() {
        let navigationDrawViewController = UINavigationController(rootViewController: DrawViewController())
        let navigationSloppyDrawingController = UINavigationController(rootViewController: SloppyDrawingViewController())
        navigationDrawViewController.tabBarItem.title = "Shape Draw"
        navigationSloppyDrawingController.tabBarItem.title = "Sloppy Draw"
		navigationSloppyDrawingController.isNavigationBarHidden = true
		navigationDrawViewController.isNavigationBarHidden = true
        self.viewControllers = [navigationSloppyDrawingController, navigationDrawViewController]
    }
}
