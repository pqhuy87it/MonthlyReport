//
//  ViewController.swift
//  BinarySearchTree
//
//  Created by Pham Quang Huy on 5/22/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let numberList = [7,2,1,5,10,9]
        let bsTree = BSTree<Int>()
        
        for number in numberList {
            bsTree.insert(element: number)
        }
        
        bsTree.root.traverse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

