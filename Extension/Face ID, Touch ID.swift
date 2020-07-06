@IBAction func authenticateTapped(_ sender: Any) {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Identify yourself!"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [weak self] success, authenticationError in

            DispatchQueue.main.async {
                if success {
                    self?.unlockSecretMessage()
                } else {
                    // error
                }
            }
        }
    } else {
        // no biometry
    }
}
