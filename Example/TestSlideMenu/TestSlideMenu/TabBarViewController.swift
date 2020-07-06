//
//  TabBarViewController.swift
//  TestSlideMenu
//
//  Created by Huy Pham Quang on 5/8/19.
//  Copyright © 2019 Huy Pham Quang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setNavigationBarItem()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TabBarViewController : SlideMenuControllerDelegate {

    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }

    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }

    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }

    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }

    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }

    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }

    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }

    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
