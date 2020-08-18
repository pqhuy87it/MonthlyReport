https://samwize.com/2015/08/07/how-to-handle-remote-notification-with-background-mode-enabled/

iOS push notification has evolved greatly over the years, from a simple push with a alert string, to the now sophisticated system involving custom actions, localized string and background mode.
Reading the documentations here, here and here… provided clues everywhere on how it works.
This post is to explain what happens when a push reaches a device.
Which delegate method is called?

That is the question to answer when a push reaches a device.
Three possible callbacks:
application:didReceiveRemoteNotification:fetchCompletionHandler:
application:didFinishLaunchingWithOptions:
No callback
There are other callback methods in UIApplicationDelegate, but we leave omit them in this discussion unless it is needed. Specifically they are:
application:didReceiveRemoteNotification: - This is the original API when push notification service is launched (iOS 3.0), but now it is superceded by application:didReceiveRemoteNotification:fetchCompletionHandler: (iOS 7.0).
application:handleActionWithIdentifier:forRemoteNotification:completionHandler: - This is for providing custom action that goes with a push notification (iOS 8.0). An advanced topic we shelf off for now.
Configuring The Payload & Silent Push

The push notification payload consists of:
alert - the alert string and actions
badge
sound
content-available
The key content-available is a new feature, and it is this key that makes silent push possible.
To enable, you also have to add remote-notifcation as your app UIBackgroundModes as described here.
This is what happens when content-available is in the payload:
If app is Suspended, the system will bring it into Background
If app was killed by user, nothing happens and app remains in Not Running
Read about app state changes.
A potential is pitfall:
You enable with content-available=1. But, it is WRONG to disable with content-available=0. To disable, you have to REMOVE the key in the payload.
Playing out the Scenarios

With content-available enabled:
App is in Foreground
No system alert shown
application:didReceiveRemoteNotification:fetchCompletionHandler: is called
App is in Background
System alert is shown
application:didReceiveRemoteNotification:fetchCompletionHandler: is called
App is in Suspended
App state changes to Background
System alert is shown
application:didReceiveRemoteNotification:fetchCompletionHandler: is called
App is Not Running because killed by user
System alert is shown
No callback is called
With content-available disabled (key removed):
App is in Foreground
No system alert shown
application:didReceiveRemoteNotification:fetchCompletionHandler: is called
App is in Background or Suspended
System alert is shown
No method is called, but when user tap on the push and the app is opened
application:didReceiveRemoteNotification:fetchCompletionHandler: is called
App is in Not Running
System alert is shown
No method is called, but when user tap on the push and the app is opened
application:didFinishLaunchingWithOptions: then application:didReceiveRemoteNotification:fetchCompletionHandler: are both called
Conclusion

If app is in Foreground, the system will not show the alert and it is up to the app to display some UI after application:didReceiveRemoteNotification:fetchCompletionHandler: is called.
Enabling content-available will put the app in Background (unless app was killed by user) and then call application:didReceiveRemoteNotification:fetchCompletionHandler: immediately.
Whereas without content-available, app will remain in Suspended, and application:didReceiveRemoteNotification:fetchCompletionHandler: is delayed until the app is opened.
Lastly, application:didFinishLaunchingWithOptions: is called only when the app is Not Running, and the user tap on the push alert. It will subsequently call application:didReceiveRemoteNotification:fetchCompletionHandler:. Therefore, it is better to handle the push in application:didReceiveRemoteNotification:fetchCompletionHandler:, as that covers all scenarios.
