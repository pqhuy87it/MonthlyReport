https://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift

// Navigation Bar:

navigationController?.navigationBar.barTintColor = UIColor.green
//Replace greenColor with whatever UIColor you want, you can use an RGB too if you prefer.

//Navigation Bar Text:

navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
//Replace orangeColor with whatever color you like.

//Tab Bar:

tabBarController?.tabBar.barTintColor = UIColor.brown
//Tab Bar Text:

//tabBarController?.tabBar.tintColor = UIColor.yellow

// setup navBar.....
UINavigationBar.appearance().barTintColor = .green
UINavigationBar.appearance().tintColor = .white
UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
UINavigationBar.appearance().isTranslucent = false
