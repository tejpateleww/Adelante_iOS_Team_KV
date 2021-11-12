//
//  AppDelegate.swift
//  ApiStructureModule
//
//  Created by EWW071 on 13/03/20.
//  Copyright © 2020 EWW071. All rights reserved.
//  pod 'BraintreeDropIn'

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import CoreLocation
import GooglePlaces
import GoogleMaps
import Braintree

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager? 
    var fromPushUserId = String()
    var fromPushItemId = String()
    var shareUrl = ""
    var locationService = LocationService()
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        setupNavigation()
        BTAppContextSwitcher.setReturnURLScheme("com.eww.adelante.payments")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        FirebaseApp.configure()
        if let url = launchOptions?[.url] as? URL, let annotation = launchOptions?[.annotation] {
            return self.application(application, open: url)//(application, open: url, sourceApplication: launchOptions?[.sourceApplication] as? String, annotation: annotation)
        }
        checkAndSetDefaultLanguage()
        navigateToSplash()
        
//        printAppFonts()
        setUpLocationServices()
        
        FirebaseApp.configure()
        
        registerForPushNotifications()
        GMSServices.provideAPIKey("AIzaSyAanqcKJTTvrFIsWqQRCjTdecR_CpPZo0E")
        GMSPlacesClient.provideAPIKey("AIzaSyAanqcKJTTvrFIsWqQRCjTdecR_CpPZo0E")
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        print("click url is \(url)")
//        let token = url.valueOf("token") ?? ""
//        let email = url.valueOf("email") ?? ""
//
//        return true
//    }
    func setUpLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if ((locationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) != nil)
            {
                if locationManager?.location != nil
                {
                    locationManager?.startUpdatingLocation()
                    locationManager?.delegate = self
                }
                //                manager.startUpdatingLocation()
            }
        }
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url)
            let myUrl: String? = userActivity.webpageURL?.absoluteString
            let itemID = url.valueOf("orderid")
            fromPushItemId = itemID ?? ""
            if myUrl?.range(of: "ShareOrder") != nil {
                if let _ = (self.window?.rootViewController as! UINavigationController).viewControllers.first as? SplashVC {
                    NotificationCenter.default.addObserver(self, selector: #selector(OnLinkClickToNavigate), name: NSNotification.Name(rawValue: NotificationKeys.PushOnLinkClick), object: nil)
                }
                else {
                    OnLinkClickToNavigate()
                }
                
            }
        }
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appUrl = URL(string: shareUrl)
        if UIApplication.shared.canOpenURL(appUrl!) {
            UIApplication.shared.open(appUrl!, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(appUrl!, options: [:], completionHandler: { (success) in
                 print("Open url : \(success)")
            })
        }
        if url.scheme?.localizedCaseInsensitiveCompare("com.eww.adelante.payments") == .orderedSame {
                return BTAppContextSwitcher.handleOpenURL(url)
            }
      return true
    }
    @objc func OnLinkClickToNavigate(){
        
        if UserDefaults.standard.value(forKey: "isUserLogin") != nil{
            if UserDefaults.standard.value(forKey: "isUserLogin") as! Bool{
                webserviceShareOrder(strMainOrderId: fromPushItemId)
                if let Navigation = appDel.window?.rootViewController as? UINavigationController{
                    let tabVC = Navigation.children.first as? CustomTabBarVC
                    if tabVC?.selectedIndex == 3 || tabVC?.selectedIndex == 0 || tabVC?.selectedIndex == 1 || tabVC?.selectedIndex == 4{
                        let selectedIndex = tabVC?.selectedIndex
                        let nav = tabVC?.children[selectedIndex!] as? UINavigationController
                        if ((nav?.topViewController as? MyOrdersVC) != nil){
                            if nav?.presentedViewController != nil{
                                if (nav?.presentedViewController?.isKind(of: MyOrdersVC.self)) != nil{
                                    nav?.dismiss(animated: true, completion: nil)
                                }
                            }
                            let ItemDetailVC = nav?.topViewController as! MyOrdersVC
                            ItemDetailVC.strOrderId = fromPushItemId
                            SingletonClass.sharedInstance.selectInProcessShareOrder = true
                            ItemDetailVC.webserviceGetOrderDetail(selectedOrder: ItemDetailVC.strOrderId)
                        }
                        
                        else{
                            if let TabVC =  appDel.window?.rootViewController?.children.first {
                                if TabVC.isKind(of: CustomTabBarVC.self) {
                                    SingletonClass.sharedInstance.selectInProcessShareOrder = true
                                    let vc = TabVC as! CustomTabBarVC
                                    vc.selectedIndex = 2
                                }
                            }
                        }
                    }
                    else {
                        if let TabVC =  appDel.window?.rootViewController?.children.first {
                            if TabVC.isKind(of: CustomTabBarVC.self) {
                                SingletonClass.sharedInstance.selectInProcessShareOrder = true
                                let vc = TabVC as! CustomTabBarVC
                                vc.selectedIndex = 2
                            }
                        }
                    }
                }
            }
            else{
                Utilities.ShowAlert(OfMessage: "Please login before you proceed")//OkalerwithAction(Msg: "Please login before you proceed") {
            }
        }
        else {
            Utilities.ShowAlert(OfMessage: "Please login before you proceed")//OkalerwithAction(Msg: "Please login before you proceed") {
        }
        
    }
    func webserviceShareOrder(strMainOrderId:String){
        let shareOrder = shareOrderReqModel()
        shareOrder.user_type = SingletonClass.sharedInstance.LoginRegisterUpdateData?.email ?? ""
        shareOrder.main_order_id = strMainOrderId
        WebServiceSubClass.ShareOrder(shareOrder: shareOrder, showHud: false, completion: { (json, status, response) in
            if(status)
            {
                
            }
            else
            {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
    }
   
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    func checkAndSetDefaultLanguage() {
            if userDefault.value(forKey: UserDefaultsKey.selLanguage.rawValue) == nil {
                setLanguageEnglish()
            }
        }
        
        func setLanguageEnglish() {
            userDefault.setValue("en", forKey: UserDefaultsKey.selLanguage.rawValue)
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
    func performLogout(){
        let logout = LogoutReqModel()
        logout.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Logout(logoutModel: logout, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                appDel.SetLogout()
            }else{
               
            }
        })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification)
        
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        print(appDel.window?.rootViewController?.navigationController?.children.first as Any)
        
        NotificationCenter.default.post(name: NotificationBadges, object: content)
        completionHandler([.alert, .sound])
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")

        if key as? String ?? "" == PushNotifications.logout.Name {
            self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
        } else {
         //   self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //        if let refreshedToken = InstanceID.instanceID().token() {
        //            print("InstanceID token: \(refreshedToken)")
        //        }
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = fcmToken ?? "No Token found"
        print("Firebase registration token: \(fcmToken ?? "No Token found")")
        SingletonClass.sharedInstance.DeviceToken = token
        userDefault.set(fcmToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
        
        
        let dataDict:[String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        Messaging.messaging().token { token, error in
            // Check for error. Otherwise do what you will with token here
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result)")
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
    func SetLogout() {
        // Reset UserDefaults
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        userDefault.set(false, forKey: UserDefaultsKey.isUserLogin.rawValue)
        SingletonClass.sharedInstance.clearSingletonClass()
        self.checkAndSetDefaultLanguage()
        self.navigateToLogin()
    }
    // MARK: - LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        SingletonClass.sharedInstance.userCurrentLocation = location
        //print(location.coordinate.latitude)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        
//        SingletonClass.sharedInstance.arrCarLists
        
        print("Error: \(error)")
    }
    
}

extension AppDelegate {
    func handlePushnotifications(NotificationType:String , userData : [AnyHashable : Any]) {
        print(userData)
        
        switch NotificationType {
        case PushNotifications.logout.Name:
            Utilities.hideHud()
            appDel.SetLogout()
        default:
            break
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        
        let currentDate = Date()
        print("currentDate : \(currentDate)")
        
    }
    
  
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        if(application.applicationState == .inactive)
        {
            
        }
        else
        if(application.applicationState == .active)
        {
            self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
            /*
             # App is currently active, can update badges count here
             */
        }
        else if(application.applicationState == .background)
        {
            
            //self.handlePushnotifications(NotificationType: key as? String ?? "", userData: userInfo)
            /* # App is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here */
        }
        
        print(userInfo)
        
        
        
        
        
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(#function)
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    
    
}
