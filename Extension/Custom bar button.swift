func addNavigationBarButton(imageName:String,direction:direction){
    var image = UIImage(named: imageName)
    image = image?.withRenderingMode(.alwaysOriginal)
    switch direction {
    case .left:
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: #selector(goBack))
    case .right:
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: #selector(goBack))
    }
}

@objc func goBack() {
    navigationController?.popViewController(animated: true)
}

enum direction {
    case right
    case left
}
