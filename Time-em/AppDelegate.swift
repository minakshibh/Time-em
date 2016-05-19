//
//  AppDelegate.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard:UIStoryboard?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.createCopyOfDatabaseIfNeeded()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func createCopyOfDatabaseIfNeeded() {
        // First, test for existence.
        // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        var error: NSError
        var documentsDir: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        var dbPath: String = documentsDir.stringByAppendingString("/Time-em.sqlite")
        NSLog("db path %@", dbPath)
        NSLog("File exist is %hhd", fileManager.fileExistsAtPath(dbPath))
        var success: Bool = fileManager.fileExistsAtPath(dbPath)
        if !success {
            var defaultDBPath: String = NSBundle.mainBundle().resourcePath!.stringByAppendingString("/Time-em.sqlite")
            NSLog("default DB path %@", defaultDBPath)
            //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
            var success:Bool = false
            do {
                success = true
                try fileManager.copyItemAtURL(NSURL(string:defaultDBPath)!, toURL:NSURL(string: dbPath)!)
            } catch _ {
                success = false
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

