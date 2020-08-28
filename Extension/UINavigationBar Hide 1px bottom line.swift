https://stackoverflow.com/questions/19226965/how-to-hide-uinavigationbar-1px-bottom-line

![](https://i.stack.imgur.com/iE0SO.png)

For iOS 13

let navigationBar = navigationController?.navigationBar
let navigationBarAppearence = UINavigationBarAppearance()
navigationBarAppearence.shadowColor = .clear
navigationBar?.scrollEdgeAppearance = navigationBarAppearence

For iOS 12 and below:

let navigationBar = navigationController!.navigationBar
navigationBar.setBackgroundImage(#imageLiteral(resourceName: "BarBackground"),
                                                        for: .default)
navigationBar.shadowImage = UIImage()

Above is the only "official" way to hide it. Unfortunately, it removes bar's translucency.

I don't want background image, just color

You have those options:

Solid color, no translucency:

navigationBar.barTintColor = UIColor.redColor()
navigationBar.isTranslucent = false
navigationBar.setBackgroundImage(UIImage(), for: .default)
navigationBar.shadowImage = UIImage()
Create small background image filled with color and use it.
Use 'hacky' method described below. It will also keep bar translucent.
