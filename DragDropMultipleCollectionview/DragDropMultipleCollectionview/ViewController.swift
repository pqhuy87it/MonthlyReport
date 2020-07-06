//
//  ViewController.swift
//  DragDropMultipleCollectionview
//
//  Created by Huy Pham Quang on 8/22/18.
//  Copyright © 2018 みかん方や. All rights reserved.
//

import UIKit

class DataItem : Equatable {

    var indexes: String
    var colour: UIColor
    init(_ indexes: String, _ colour: UIColor = UIColor.clear) {
        self.indexes    = indexes
        self.colour     = colour
    }

    static func ==(lhs: DataItem, rhs: DataItem) -> Bool {
        return lhs.indexes == rhs.indexes && lhs.colour == rhs.colour
    }
}

let colours = [UIColor.kdBrown, UIColor.kdGreen, UIColor.kdBlue]

class ViewController: UIViewController, DragDropCollectionViewDataSource, DragDropCollectionViewDelegate {

    @IBOutlet weak var firstCollectionView: DragDropCollectionView!
    @IBOutlet weak var secondCollectionView: DragDropCollectionView!
    @IBOutlet weak var thirdCollectionView: DragDropCollectionView!

    var data : [[DataItem]] = [[DataItem]]()

    var dragAndDropManager : DragDropManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // generate some mock data (change in real world project)
        self.data = (0...2).map({ i in (0...20).map({ j in DataItem("\(String(i)):\(String(j))", colours[i])})})

        self.dragAndDropManager = DragDropManager (
            canvas: self.view,
            collectionViews: [firstCollectionView, secondCollectionView, thirdCollectionView]
        )

    }

    // MARK : UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].count
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorCell

        let dataItem = data[collectionView.tag][indexPath.item]

        cell.label.text = String(indexPath.item) + "\n\n" + dataItem.indexes
        cell.backgroundColor = dataItem.colour

        cell.isHidden = false

        if let kdCollectionView = collectionView as? DragDropCollectionView {

            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingIndexPath {

                if draggingPathOfCellBeingDragged.item == indexPath.item {

                    cell.isHidden = true

                }
            }
        }

        return cell
    }

    // MARK : KDDragAndDropCollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return data[collectionView.tag][indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {

        if let di = dataItem as? DataItem {
            data[collectionView.tag].insert(di, at: indexPath.item)
        }


    }
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        data[collectionView.tag].remove(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {

        let fromDataItem: DataItem = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        data[collectionView.tag].insert(fromDataItem, at: to.item)

    }

    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {

        guard let candidate = dataItem as? DataItem else { return nil }

        for (i,item) in data[collectionView.tag].enumerated() {
            if candidate != item { continue }
            return IndexPath(item: i, section: 0)
        }

        return nil

    }

    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row % 2 == 0
    }

    func collectionView(_ collectionView: UICollectionView, stylingRepresentationView: UIView) -> UIView? {
        return nil
    }
}

