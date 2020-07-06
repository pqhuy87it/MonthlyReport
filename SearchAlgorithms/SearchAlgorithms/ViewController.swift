//
//  ViewController.swift
//  SearchAlgorithms
//
//  Created by Pham Quang Huy on 4/10/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // An unsorted array of numbers
        let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]
        
        // Binary search requires that the array is sorted from low to high
        let sorted = numbers.sorted()
        
        let index = linearSearch(a: sorted, key: 19)
        print(index ?? "nil")
        
        let index1 = interpolationSearch(sorted, key: 19)
        print(index1 ?? "nil")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func linearSearch<T: Comparable>(a: [T], key: T) -> Int? {
        
        //check all possible values
        for (index, number) in a.enumerated() {
            if number == key {
                return index
            }
        }
        
        return nil
    }
    
    func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
        var lowerBound = 0
        var upperBound = a.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if a[midIndex] == key {
                return midIndex
            } else if a[midIndex] < key {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
    
    func interpolationSearch(_ a: [Int], key: Int) -> Int? {
        let lowerBound = 0
        var midIndex = -1
        var upperBound = a.count - 1
        
        while lowerBound != upperBound && a[lowerBound] != a[upperBound] {
            midIndex = lowerBound + ((upperBound - lowerBound) / (a[upperBound] - a[lowerBound])) * (key - a[lowerBound])
            
            if a[midIndex] == key {
                return midIndex
            } else {
                if a[midIndex] < key {
                    upperBound = midIndex + 1
                } else if a[midIndex] > key {
                    upperBound = midIndex - 1
                }
            }
        }
        
        return nil
    }

}

