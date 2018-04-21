//
//  AppDelegate.swift
//  Ngage
//
//  Created by Mark Louie Angeles on 24/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FBSDKLoginKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("DID FINISH LAUNCH")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        UserDefaults.standard.set(false, forKey: Keys.keyShouldEdit)
        
        if CoreDataManager.sharedInstance.getMainUser() != nil {
            let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: Bundle.main)
            let controller = storyboard.instantiateInitialViewController()
            window?.rootViewController = controller
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("DID ENTER FOREGROUND")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("DID BECOME ACTIVE")
        TimeManager.sharedInstance.setTimer()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().isAutoInitEnabled = true
        let apnsToken = Messaging.messaging().apnsToken
        print("APNS TOKEN")
        print(apnsToken)
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        let notifModel = NotificationModel()
        notifModel.id = 101
        notifModel.body = token
        
        
        Messaging.messaging().delegate = self
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Message has been received = \(userInfo)")
    }

    

}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let notifModel = NotificationModel()
        notifModel.id = 100
        notifModel.body = fcmToken
        CoreDataManager.sharedInstance.saveModelToCoreData(withModel: notifModel as AnyObject) { (result) in
            
        }
        print("FCM Token = \(fcmToken)")
        print("Instance ID = \(InstanceID.instanceID().token())")
        
        CoreDataManager.sharedInstance.saveModelToCoreData(withModel: notifModel as AnyObject) { (result) in
            
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        UserDefaults.standard.setValue(fcmToken, forKey: Keys.DeviceID)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notifModel = NotificationModel()
        notifModel.id = CoreDataManager.sharedInstance.getNotifcationCount()
        notifModel.body = response.notification.request.content.body
        
        CoreDataManager.sharedInstance.saveModelToCoreData(withModel: notifModel as AnyObject) { (result) in
            
        }
        
    }
    
}

