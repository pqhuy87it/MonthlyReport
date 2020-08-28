https://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked

override func viewDidAppear(_ animated: Bool) {
    let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)

    present(alertController, animated: true, completion: nil)
}

------

UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
