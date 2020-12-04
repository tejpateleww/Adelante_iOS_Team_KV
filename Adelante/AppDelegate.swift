//
//  AppDelegate.swift
//  ApiStructureModule
//
//  Created by EWW071 on 13/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        setupNavigation()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    //    FirebaseApp.configure()
        registerForPushNotifications()
        navigateToSplash()
//        printAppFonts()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func setupNavigation(){
        if #available(iOS 13.0, *) {
            // prefer a light interface style with this:
            //  window?.overrideUserInterfaceStyle = .light
        }
        let attributes = [NSAttributedString.Key.font: CustomFont.NexaBold.returnFont(20),NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = true
        
    }
    
    func printAppFonts() {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    func setUpInitialVC() {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == true{
            navigateToHome()
        } else {
            navigateToMainLogin()
        }
    }
    
    func navigateToHome() {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
    }
    
    func navigateToMainLogin() {
       let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: MainLoginVC.storyboardID) as? MainLoginVC
       let nav = UINavigationController(rootViewController: controller!)
        nav.navigationBar.isHidden = true
       self.window?.rootViewController = nav
    }
    
    func navigateToLogin() {
       let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as? LoginViewController
       let nav = UINavigationController(rootViewController: controller!)
        nav.navigationBar.isHidden = true
       self.window?.rootViewController = nav
    }
    
    func navigateToSplash() {
       let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SplashVC.storyboardID) as? SplashVC
       let nav = UINavigationController(rootViewController: controller!)
        nav.navigationBar.isHidden = true
       self.window?.rootViewController = nav
    }
    
    func clearData()
    {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            
            if key != UserDefaultsKey.DeviceToken.rawValue && key  != "language"  {
                print("\(key) = \(value) \n")
                 UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isUserLogin.rawValue)
        
        SingletonClass.sharedInstance.clearSingletonClass()
    }
    

    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_ , _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification)
        
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        print(appDel.window?.rootViewController?.navigationController?.children.first as Any)
        
        NotificationCenter.default.post(name: NotificationBadges, object: content)
        completionHandler([.alert, .sound])
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //        if let refreshedToken = InstanceID.instanceID().token() {
        //            print("InstanceID token: \(refreshedToken)")
        //        }
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        SingletonClass.sharedInstance.DeviceToken = fcmToken
        userDefault.set(fcmToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
        
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
                UserDefaults.standard.set(SingletonClass.sharedInstance.DeviceToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    
}

