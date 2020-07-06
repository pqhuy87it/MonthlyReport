//
//  ViewController.swift
//  UsingDispatchSemaphore
//
//  Created by Huy Pham on 6/23/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Parameters - UIKit
    
    @IBOutlet weak var btnStart: BorderButton!
    @IBOutlet weak var btnPause: BorderButton!
    @IBOutlet weak var btnStop: BorderButton!
    @IBOutlet weak var btnResume: BorderButton!
    
    // MARK: Parameters - User
    
    var semaphoreManager: SemaphoreManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        semaphoreManager = SemaphoreManager(numberThread: 3)
    }
    
    // MARK: Methods - Override

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods - IBActions
    
    @IBAction func startPressed(sender: AnyObject) {
        setEnabled(false, forButton: btnStart)
        setEnabled(false, forButton: btnResume)
        setEnabled(true, forButton: btnPause)
        setEnabled(true, forButton: btnStop)
        
        var listTask = [Task]()
        
        for i in 0..<200 {
            let time = Int(arc4random_uniform(10) + 3)
            let task = Task(id: i, time: time)
            listTask.append(task)
        }
        
        semaphoreManager.getTasks(listTask)
    }
    
    @IBAction func pausePressed(sender: AnyObject) {
        setEnabled(false, forButton: btnPause)
        setEnabled(true, forButton: btnResume)
        semaphoreManager.pause()
    }

    @IBAction func stopPressed(sender: AnyObject) {
        setEnabled(false, forButton: btnPause)
        setEnabled(false, forButton: btnResume)
        setEnabled(false, forButton: btnStop)
        setEnabled(true, forButton: btnStart)
        semaphoreManager.stop()
    }
    
    @IBAction func resumePressed(sender: AnyObject) {
        setEnabled(false, forButton: btnResume)
        setEnabled(true, forButton: btnPause)
        setEnabled(true, forButton: btnStop)
        semaphoreManager.resume()
    }
    
    // MARK: Methods - Private Functions
    
    private func setEnabled(enabled: Bool, forButton button: BorderButton) {
        button.enabled = enabled
        button.borderColor = enabled ? UIColor.greenColor() : UIColor.redColor()
    }
}

extension ViewController: SemaphoreManagerDelegate {
    func didFinishService() {
        setEnabled(true, forButton: btnStart)
        setEnabled(false, forButton: btnPause)
        setEnabled(false, forButton: btnStart)
        setEnabled(false, forButton: btnResume)
    }
}

