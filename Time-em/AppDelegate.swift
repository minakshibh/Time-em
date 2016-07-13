//
//  AppDelegate.swift
//  Time-em
// self.dispatch = false
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import AVFoundation
import TSMessages
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var storyboard:UIStoryboard?
    let navigator:UINavigationController? = nil
    var locationManager = CLLocationManager()
    var localNotification:UILocalNotification =  UILocalNotification()
    var afterResume:Bool!
    var anotherLocationManager:CLLocationManager!
    var  IS_OS_8_OR_LATER = (Int(UIDevice.currentDevice().systemVersion) >= 8)
    var myLocation:CLLocationCoordinate2D!
    var myLocationAccuracy:CLLocationAccuracy!
    var timer:NSTimer!
    var delay10Seconds:NSTimer! = nil
    var locationStatus : NSString = "Not Started"

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        //--
//        if (launchOptions![UIApplicationLaunchOptionsLocationKey] != nil) {
//            self.locationManager = CLLocationManager()
//            self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            self.locationManager.activityType = .OtherNavigation
//            if IS_OS_8_OR_LATER {
//                self.locationManager.requestAlwaysAuthorization()
//            }
//            self.locationManager.startMonitoringSignificantLocationChanges()
//        }
        initLocationManager();
        
        
        
        
        
        if launchOptions?[UIApplicationLaunchOptionsLocationKey] != nil {
            print("It's a location event")
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        
        
        window?.backgroundColor = UIColor.blackColor()
        self.createCopyOfDatabaseIfNeeded()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController:UIViewController!
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") != nil){
            rootViewController = storyboard.instantiateViewControllerWithIdentifier("passCode") as! passCodeViewController
        }else{
            rootViewController = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        }
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
        /// setup for notifications
        let notificationTypes = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationTypes)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
        if NSUserDefaults.standardUserDefaults().valueForKey("data") != nil {
            
            let data = NSUserDefaults.standardUserDefaults().valueForKey("data")!
            let arr1:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as? NSMutableArray)!
            print(arr1)
        }
       
        

        
        
        return true
        //performFetchWithCompletionHandler
    }
    
    func initLocationManager() {
        delay(0.001) {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        CLLocationManager.locationServicesEnabled()
        self.locationManager.requestAlwaysAuthorization()
                if #available(iOS 9.0, *) {
                    self.locationManager.allowsBackgroundLocationUpdates = true
                    
                } else {
                    // Fallback on earlier versions
                }
            
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
//        self.locationManager.startMonitoringSignificantLocationChanges()
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
                print("location error:- \(error)")
            
        
    }
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat"%@",newHeading] delegate:self cancelButtonTitle"OK" otherButtonTitles: nil];
        //    [alert show];
        //    NSLog(@"%@",newHeading);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        NSLog("locationManager didUpdateLocations: %@", locations)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            localNotification.alertAction = "Time'em"
            localNotification.alertBody = "App is going offline. To stay online open the app."
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
        
        var strlatlon:String!
        for var i = 0; i < locations.count; i++ {
            
            var newLocation: CLLocation = locations[i]
            var theLocation: CLLocationCoordinate2D = newLocation.coordinate
            var theAccuracy: CLLocationAccuracy = newLocation.horizontalAccuracy
            self.myLocation = theLocation
            self.myLocationAccuracy = theAccuracy
//            let dict:NSMutableDictionary = [:]
//            dict["lat"] = newLocation.coordinate.latitude
//            dict["lov"] = newLocation.coordinate.longitude
            
            let state = UIApplication.sharedApplication().applicationState
            if state == .Background {
//                print("App in Background")
//                dict["app mode"] = "App is in Background"
            }else if state == .Active {
//                dict["app mode"] = "App is Active"
//                print("App in Active")
            }else if state == .Inactive {
//                dict["app mode"] = "App is Inactive"
//                print("App in Inactive")
            }
            
            
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneStr = formatter.stringFromDate(NSDate())
            // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
            formatter.timeZone = NSTimeZone(abbreviation: "IST")
            let utcTimeZoneStr = formatter.stringFromDate(NSDate())
            
//            dict["date"] = utcTimeZoneStr
            let arr:NSMutableArray = []
//            arr.addObject(dict)
            
//             strlatlon = "19.225842,72.9766845"

            if NSUserDefaults.standardUserDefaults().valueForKey("data") != nil {
                
               let data = NSUserDefaults.standardUserDefaults().valueForKey("data")!
                let arr1:NSMutableArray =  (NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as? NSMutableArray)!
//                arr1.addObject(dict)
                 let data1 = NSKeyedArchiver.archivedDataWithRootObject(arr1)
                NSUserDefaults.standardUserDefaults().setObject(data1, forKey: "data")
            }else{
            let data = NSKeyedArchiver.archivedDataWithRootObject(arr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "data")
            }
           // (latitude,longitude)
           
            
        }
        
        if self.timer != nil{
           return
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: #selector(AppDelegate.updateLocationPer5mins), userInfo: nil, repeats: true)
    }
    
    func updateLocationPer5mins() {
        print("timer.timer")
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil{
            if locationManager.location?.coordinate.latitude != nil {
            print("jijijijiji\(locationManager.location?.coordinate.latitude)")
            let strUSerId = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")!)"
            let latlat = roundToPlaces((locationManager.location?.coordinate.latitude)!, places: 2)
            let lonlon = roundToPlaces((locationManager.location?.coordinate.longitude)!, places: 2)
            let strlatlon = "\(latlat),\(lonlon)"
            
            let api = ApiRequest()
            api.sendUsersTimeIn(strUSerId, points: strlatlon)
            }
        }
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    // authorization status
    func locationManager(manager: CLLocationManager!,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
//    
//    
//    
//    
//    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        if self.window?.rootViewController?.presentedViewController is chartViewController {
//            
//            let secondController = self.window!.rootViewController!.presentedViewController as! chartViewController
//            
//            if secondController.isPresented {
//                return UIInterfaceOrientationMask.LandscapeLeft;
//            } else {
//                return UIInterfaceOrientationMask.Portrait;
//            }
//            
//        } else {
//            
//            return UIInterfaceOrientationMask.Portrait;
//        }
//    
//    
//    
//    }
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //send this device token to server
       
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("tokenString: \(tokenString)")
        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "tokenString")
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
         application.registerForRemoteNotifications()
    }
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        print(error)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Recived: \(userInfo)")
        //Parsing userinfo:
        let temp : NSDictionary = userInfo
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
              let alertMsg = info["alert"] as! String
//            TSMessage.showNotificationWithTitle("Time'em", subtitle: alertMsg, type:TSMessageNotificationType.Warning)
          
            var alert: UIAlertView!
            alert = UIAlertView(title: "Time-em", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()

        
        if(IS_OS_8_OR_LATER) {
             self.locationManager.requestAlwaysAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        delay(0.001) {
            
        self.locationManager.stopMonitoringSignificantLocationChanges()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.activityType = .OtherNavigation
                if #available(iOS 9.0, *) {
                    self.locationManager.allowsBackgroundLocationUpdates = true
                } else {
                    // Fallback on earlier versions
                }
        if(self.IS_OS_8_OR_LATER) {
            self.locationManager.requestAlwaysAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        }
    }
    

    func applicationWillTerminate(application: UIApplication) {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func createCopyOfDatabaseIfNeeded() {
        // First, test for existence.
        // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let error: NSError
        let documentsDir: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let dbPath: String = documentsDir.stringByAppendingString("/Time-em.sqlite")
        NSLog("db path %@", dbPath)
        NSLog("File exist is %hhd", fileManager.fileExistsAtPath(dbPath))
        let success: Bool = fileManager.fileExistsAtPath(dbPath)
        if !success {
            let defaultDBPath: String = NSBundle.mainBundle().pathForResource("Time-em", ofType: "sqlite")!
//            resourcePath!.stringByAppendingString("/Time-em.sqlite")
            NSLog("default DB path %@", defaultDBPath)
            //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
            var success:Bool = false
            do {
                success = true
                try fileManager.copyItemAtURL(NSURL.fileURLWithPath(defaultDBPath), toURL:NSURL.fileURLWithPath(dbPath))
            } catch let error as NSError {
                success = false
                
                print("failed: \(error.localizedDescription)")
                print("Couldn't copy file to final location!")
            }
            
            
            if !success {
                NSLog("Failed to create writable DB. Error '%@'.")
            }
            else {
                NSLog("DB copied.")
            }
        }
        else {
            NSLog("DB exists, no need to copy.")
        }
    }
    
}

