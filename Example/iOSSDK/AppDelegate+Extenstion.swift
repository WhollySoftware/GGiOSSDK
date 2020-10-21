

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //MARK:- Register for push notification.
    func registerForRemoteNotifications(application: UIApplication) {
        debugPrint("Registering for Push Notification...")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions, completionHandler: { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async(execute: {
                            application.registerForRemoteNotifications()
                        })
                    } else {
                        debugPrint("Error Occurred while registering for push \(String(describing: error?.localizedDescription))")
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
    @objc func tokenRefreshNotification(_ notification: Notification) {
        print(#function)
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.token = result.token
            }
        }
    }
}
