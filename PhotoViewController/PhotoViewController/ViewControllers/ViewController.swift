//
//  ViewController.swift
//  PhotoViewController
//
//  Created by Pham Quang Huy on 1/28/18.
//  Copyright © 2018 Pham Quang Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = []
    var itemUrls: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.items = ["Flower", "Glaxy", "Glaxy 2", "Earth", "Earth 2"]
        self.itemUrls = [
            "https://static.pexels.com/photos/36753/flower-purple-lical-blosso.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/5/52/Hubble2005-01-barred-spiral-galaxy-NGC1300.jpg",
            "http://wallpapers1080p.com/wallpaper/walls/1/distant-galaxy-6k.jpg",
            "http://orig04.deviantart.net/c3eb/f/2014/025/7/6/6k_earth_by_rich33584-d73nozm.jpg",
            "https://i.ytimg.com/vi/l2gh33F6o-Q/maxresdefault.jpg"
        ]
    }

    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.itemUrls[indexPath.row]
        if let photoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
            let photo = Photo(url)
            photoViewController.photo = photo
            self.present(photoViewController, animated: true, completion: nil)
        }
    }
}
