//
//  AppDelegate.swift
//  Audit House
//
//  Created by Sandesh on 08/04/20.
//  Copyright © 2020 Doshaheen Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = Reachabiility.shared
        requestForPushNotificationPermission()
        //handle notification is app was not in running state
        handleNotification(with: launchOptions)
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "AuditHouse")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func requestForPushNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){ status, error in
            if error == nil {
                switch status {
                case true:
                    print("Permisiion Granted")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    UNUserNotificationCenter.current().delegate = self
                case false: print("Permission Denied")
                }
            }
        }
    }
    
    private func handleNotification(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            _ = PushNotification(notification: aps)
        }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.tokenString
        print("Push Notification Token: \(token)")
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.DEVICE_TOKEN_KEY)
        CheckDeviceApiCall.async { _ in }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to push notification => \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let message = notification.request.content.body
        _ = PushNotification(message)
        completionHandler(.sound)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let message = response.notification.request.content.body
         _ = PushNotification(message)
        print("Tapped")
        completionHandler()
    }
}

