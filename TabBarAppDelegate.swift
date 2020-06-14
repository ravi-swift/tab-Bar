//
//  AppDelegate.swift
//  UncleHelp
//
//  Created by Dharmesh Sonani on 27/11/18.
//  Copyright © 2018 Dharmesh Sonani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var strDeviceToken : String = ""
    var dicLoginDetail : NSDictionary!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.delegate  = self
            center.requestAuthorization(options:[.badge,.sound,.alert]) { (granted, error) in
                if (granted)
                {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else{
            
            let settings = UIUserNotificationSettings(types: [.badge,.sound,.alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        }
        
       // self.ConnectToFCM()
      
        return true
    }
    
    func ConnectToFCM() {
        
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.strDeviceToken = result.token
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     
        completionHandler(.alert)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print("%@", remoteMessage.appData)
        
    }
    
    func setupTabbarcontroller()
    {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let tabBarcontroller = storyBoard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        
        for navigation in tabBarcontroller.viewControllers!
        {
            let nav = navigation as! UINavigationController
            nav.navigationBar.barTintColor = UIColor.init(red: 128.0/255.0, green: 186.0/255.0, blue: 65.0/255.0, alpha: 1.0)
            nav.navigationBar.isHidden = false
            
            let controller = nav.viewControllers[0] as! UIViewController
                
                if controller.isKind(of: ProfileViewController.self)
                {
                    nav.tabBarItem.image = #imageLiteral(resourceName: "user_toolbar")
                    nav.tabBarItem.title = "Profile"
                }
                else if controller.isKind(of: MyBookingViewController.self)
                {
                    nav.tabBarItem.image = #imageLiteral(resourceName: "mybooking")
                    nav.tabBarItem.title = "My Bookings"
                }
                else if controller.isKind(of: SearchViewController.self){
                    nav.tabBarItem.image = #imageLiteral(resourceName: "search_icon")
                    nav.tabBarItem.title = "Search"
                }
                else {
                    nav.tabBarItem.image = #imageLiteral(resourceName: "bell_icon_toolbar")
                    nav.tabBarItem.title = "Notification"
                }
            
        }
        
        tabBarcontroller.tabBar.barTintColor = UIColor.white
        tabBarcontroller.tabBar.unselectedItemTintColor = UIColor.gray
        tabBarcontroller.tabBar.tintColor = UIColor.init(red: 128.0/255.0, green: 186.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        tabBarcontroller.selectedIndex = 2
        
        self.window?.rootViewController = tabBarcontroller
        self.window?.makeKeyAndVisible()
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
         self.ConnectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

