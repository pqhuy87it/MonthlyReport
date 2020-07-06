//
//  ViewController.swift
//  LinkedList
//
//  Created by Exlinct on 7/29/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var numberList = [8, 2, 10, 9, 7, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // test tao 1 link list voi gia tri la Int
        testCreateLinkedList()
        
        // test tao 1 node tai cuoi danh sach
        testAddNodeAtLast()
        
        // test tao 1 node gia tri la 20 tai index 4
        testAddNodeAtIndex()
        
        // test remove last node
        testRemoveLastNode()
        
        // test remove 1 node tai index 4
        removeLinkAtIndex()
    }
    
    
    func buildLinkedList() -> LinkedList<Int>! {
        let linkedList: LinkedList<Int> = LinkedList<Int>()
        
        //append list items
        for number in numberList {
            linkedList.addLink(number)
        }
        
        return linkedList
    }
    
    func testCreateLinkedList() {
        print("------------------ Test Create With Value [8, 2, 10, 9, 7, 5] ------------------")
        let linkedList: LinkedList<Int> = self.buildLinkedList()
        
        linkedList.printAllNode()
        print("---------------------- End ----------------------")
    }
    
    func testAddNodeAtLast() {
        print("--------------- Test Add Node Last Value 10 ---------------")
        let linkedList: LinkedList<Int> = self.buildLinkedList()
        linkedList.addLink(10)
        linkedList.printAllNode()
        print("---------------------- End ----------------------")
    }
    
    func testAddNodeAtIndex() {
        print("------------------- Test Add Node At Index 4 Value 20 --------------------")
        let linkedList: LinkedList<Int> = self.buildLinkedList()
        linkedList.addLinkAtIndex(20, index: 4)
        
        linkedList.printAllNode()
        print("---------------------- End ----------------------")
    }
    
    func testRemoveLastNode() {
        print("------------- Test Remove Last Node --------------")
        let linkedList: LinkedList<Int> = self.buildLinkedList()
        linkedList.removeLastNode()
        linkedList.printAllNode()
        print("---------------------- End ----------------------")
    }
    
    func removeLinkAtIndex() {
        print("---------------- Test Remove At Index 4 --------------")
        let linkedList: LinkedList<Int> = self.buildLinkedList()
        linkedList.removeLinkAtIndex(4)
        
        linkedList.printAllNode()
        print("---------------------- End ----------------------")
    }
}

