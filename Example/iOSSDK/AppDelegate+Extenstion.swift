

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate,MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken{
            debugPrint("FCM ID:",token)
            self.token = token
        }
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//        debugPrint(userInfo)
//        completionHandler()
//    }
//
    //MARK:- Register for push notification.
    func registerForRemoteNotifications(application: UIApplication) {
        debugPrint("Registering for Push Notification...")
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
        application.registerForRemoteNotifications()
    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//
//    func application(application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
//    {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
//    {
//        debugPrint(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
}
