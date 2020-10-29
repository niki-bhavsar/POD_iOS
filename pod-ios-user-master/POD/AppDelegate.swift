// m
//  AppDelegate.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FacebookCore
import GoogleSignIn
import AVFoundation
import AlamofireNetworkActivityLogger
import IQKeyboardManager
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var player: AVAudioPlayer?
    var locationManager:CLLocationManager!
    var window : UIWindow?
    var userCode = String()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //Alamofire logs
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
        // Keyboard Manager for avoid scrolling
        IQKeyboardManager.shared().isEnabled = true
        
        
        self.determineMyCurrentLocation();
        
        GMSServices.provideAPIKey("AIzaSyBhLwHKWAzhBWYUg5fPVVxSqe7b4DAX7lM")
        GMSPlacesClient.provideAPIKey("AIzaSyBhLwHKWAzhBWYUg5fPVVxSqe7b4DAX7lM")
        
        GIDSignIn.sharedInstance().clientID = "73490473596-99b8v0bu4g6nicuv9rhhith4bd0qc0a5.apps.googleusercontent.com"//"920480468386-a3v6c07os2nre2vansr4bj1u5fv1fgj0.apps.googleusercontent.com"
        
        //Firebase
        
        FirebaseApp.configure()
        
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
        //globaltopic
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Constant.deviceToken = token ?? ""
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        let nav = UINavigationController.init(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = nav;
        window?.makeKeyAndVisible();
        UIView.appearance().isOpaque = false
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
            self.handleDynamicLink(dynamiclink)
        }
        
        return handled
    }
    
    //    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    //        return GIDSignIn.sharedInstance().handle(url)
    //    }
    
    
    func application(_ app: UIApplication, open url: URL, options:
                        [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let isDynamicLink : Bool = DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url),
           isDynamicLink {
            let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
            return handleDynamicLink(dynamicLink) || GIDSignIn.sharedInstance().handle(url)
        }
        // Handle incoming URL with other methods as necessary
        // ...
        return false
    }
    
    
    func handleDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
        guard let dynamicLink = dynamicLink else { return false }
        guard let deepLink = dynamicLink.url else { return false }
        let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
        let invitedBy = queryItems?.filter({(item) in item.name == "invitedby"}).first?.value
        
        userCode = invitedBy!
        
        UserDefaults.standard.set(userCode, forKey: "UserReferralCode")
        UserDefaults.standard.synchronize()
       
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) != nil {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            return true
        }
        return false
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken\(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken as Data
        Messaging.messaging().subscribe(toTopic: "global") { error in
            print("Subscribed to global topic")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //Print full message.
        if (application.applicationState == .active ){
            print("Active")
        } else if (application.applicationState == .background){
            print("Background")
        } else if (application.applicationState == .inactive){
            print("Inactive")
        }
        print("didReceiveRemoteNotification \(userInfo)")
        
        print(userInfo)
        
        if(AccountManager.instance().activeAccount != nil){
            let dict : [String : Any] = userInfo as! [String : Any]
            let apsDict : [String : Any] = dict["aps"] as! [String : Any]
            let alertDict : [String : Any] = apsDict["alert"] as! [String : Any]
            if let type : String = dict["Type"] as? String{
                let orderId : String = dict["OrderId"] as! String
                if(type == "1" || type == "7"){
                    let alert = UIAlertController(title:"Hi \(AccountManager.instance().activeAccount?.name ?? "")", message: alertDict["body"] as? String, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "VIEW", style: UIAlertAction.Style.default, handler: { _ in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if(type == "1" || type == "7"){
                            let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                            controller.orderID = orderId
                            if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                if((Helper.rootNavigation?.viewControllers.last?.isKind(of: OrderDetailViewController.self))!){
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateOrderDetailView"), object: orderId)
                                } else {
                                    Helper.rootNavigation?.pushViewController(controller, animated: true)
                                }
                                
                            } else {
                                Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                            }
                        } else {
                            let controller = storyboard.instantiateViewController(withIdentifier: "ReferAndEarnViewController") as! ReferAndEarnViewController
                            if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                if((Helper.rootNavigation?.viewControllers.last?.isKind(of: ReferAndEarnViewController.self))!){
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateReferAndEarnView"), object: orderId)
                                } else {
                                    Helper.rootNavigation?.pushViewController(controller, animated: true)
                                }
                                
                            } else {
                                Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                        
                    }))
                    alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: {(_: UIAlertAction!) in
                    }))
                    Helper.getTopViewController().present(alert, animated: true, completion: nil)
                }
            }
            //                    let type : String = dict["gcm.notification.Type"] as! String{}
            
        }
        
        
    }
    
    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        
        print(notification.request.content.userInfo.printJson())
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.playSound()
                if(AccountManager.instance().activeAccount != nil){
                    let dict : [String : Any] = notification.request.content.userInfo as! [String : Any]
                    let apsDict : [String : Any] = dict["aps"] as! [String : Any]
                    let alertDict : [String : Any] = apsDict["alert"] as! [String : Any]
                    if let type : String = dict["Type"] as? String{
                        let orderId : String = dict["OrderId"] as! String
                        if(type == "1" || type == "7"){
                            let alert = UIAlertController(title:"Hi \(AccountManager.instance().activeAccount?.name ?? "")", message: alertDict["body"] as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "VIEW", style: UIAlertAction.Style.default, handler: { _ in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if(type == "1"){
                                    let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                                    controller.orderID = orderId
                                    if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                        if((Helper.rootNavigation?.viewControllers.last?.isKind(of: OrderDetailViewController.self))!){
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateOrderDetailView"), object: orderId)
                                        } else {
                                            Helper.rootNavigation?.pushViewController(controller, animated: true)
                                        }
                                        
                                    } else {
                                        Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                                    }
                                } else {
                                    let controller = storyboard.instantiateViewController(withIdentifier: "ReferAndEarnViewController") as! ReferAndEarnViewController
                                    if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                        if((Helper.rootNavigation?.viewControllers.last?.isKind(of: ReferAndEarnViewController.self))!){
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateReferAndEarnView"), object: orderId)
                                        } else {
                                            Helper.rootNavigation?.pushViewController(controller, animated: true)
                                        }
                                        
                                    } else {
                                        Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                                
                            }))
                            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: {(_: UIAlertAction!) in
                            }))
                            Helper.getTopViewController().present(alert, animated: true, completion: nil)
                        }
                    }
                    //                    let type : String = dict["gcm.notification.Type"] as! String{}
                    
                }
                
            }
        }
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        print(response.notification.request.content.userInfo)
        if(AccountManager.instance().activeAccount != nil){
            let dict : [String : Any] = response.notification.request.content.userInfo as! [String : Any]
            let apsDict : [String : Any] = dict["aps"] as! [String : Any]
            let alertDict : [String : Any] = apsDict["alert"] as! [String : Any]
            if let type : String = dict["Type"] as? String{
                let orderId : String = dict["OrderId"] as! String
                if(type == "1" || type == "7"){
                    let alert = UIAlertController(title:"Hi \(AccountManager.instance().activeAccount?.name ?? "")", message: alertDict["body"] as? String, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "VIEW", style: UIAlertAction.Style.default, handler: { _ in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if(type == "1"){
                            let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                            controller.orderID = orderId
                            if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                if((Helper.rootNavigation?.viewControllers.last?.isKind(of: OrderDetailViewController.self))!){
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateOrderDetailView"), object: orderId)
                                } else {
                                    Helper.rootNavigation?.pushViewController(controller, animated: true)
                                }
                                
                            } else {
                                Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                            }
                        } else {
                            let controller = storyboard.instantiateViewController(withIdentifier: "ReferAndEarnViewController") as! ReferAndEarnViewController
                            if((Helper.rootNavigation?.isKind(of: UINavigationController.self))!){
                                if((Helper.rootNavigation?.viewControllers.last?.isKind(of: ReferAndEarnViewController.self))!){
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateReferAndEarnView"), object: orderId)
                                } else {
                                    Helper.rootNavigation?.pushViewController(controller, animated: true)
                                }
                                
                            } else {
                                Helper.rootNavigation?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                        
                    }))
                    alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: {(_: UIAlertAction!) in
                    }))
                    Helper.getTopViewController().present(alert, animated: true, completion: nil)
                }
            }
            //                    let type : String = dict["gcm.notification.Type"] as! String{}
            
        }
    }
    
    
    
    // MARK:- Messaging Delegates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                Constant.deviceToken = result.token
            }
        }
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("received remote notification")
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "NotificationSound", withExtension: "caf") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    //MARK:- To get the user current location delegate methods
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        if(Constant.currLat != userLocation.coordinate.latitude){
            DispatchQueue.global(qos: .background).async {
                print("Run on background thread")
                LoginController.SaveUserTrackingData()
                DispatchQueue.main.async {
                    print("We finished that.")
                    
                }
            }
        }
        //        print("user latitude = \(userLocation.coordinate.latitude)")
        //        print("user longitude = \(userLocation.coordinate.longitude)")
        Constant.currLat = userLocation.coordinate.latitude
        Constant.currLng = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    
    
    
}

extension String {
    public init(deviceToken: Data) {
        self = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
    }
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do{
            
            if let jsonData = data {
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } else {
                // Lossless conversion of the string was not possible
                return nil
            }
        }
        catch _{
            
        }
        return nil
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

