https://stackoverflow.com/questions/58153649/uitextfield-placeholder-changes-when-using-dark-theme

In your info.plist, set a new key ‘UIUserInterfaceStyle’ with value as ‘Light’.

After setting that, even in dark mode no font color will be changed
