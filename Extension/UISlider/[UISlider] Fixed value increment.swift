https://stackoverflow.com/questions/2519460/uislider-with-increments-of-5

let step: Float = 5
@IBAction func sliderValueChanged(sender: UISlider) {
  let roundedValue = round(sender.value / step) * step
  sender.value = roundedValue
  // Do something else with the value

}
