"You have sold 1000 apps in %d months" = "You have sold %@ apps in %d months";

let formatString = NSLocalizedString("You have sold 1000 apps in %d months",
                                         comment: "Time to sell 1000 apps")
let quantity = NumberFormatter.localizedString(from: 1000, number: .decimal)
salesCountLabel.text = String.localizedStringWithFormat(formatString, quantity, period)
