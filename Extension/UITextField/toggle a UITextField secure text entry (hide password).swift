// https://stackoverflow.com/questions/37873119/how-to-toggle-a-uitextfield-secure-text-entry-hide-password-in-swift

@IBAction func iconAction(sender: AnyObject) {
    if(iconClick == true) {
        passwordTF.secureTextEntry = false
    } else {
        passwordTF.secureTextEntry = true
    }

    iconClick = !iconClick
}
