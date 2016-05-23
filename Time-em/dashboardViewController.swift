//
//  dashboardViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 13/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import KGModal
import FMDB

class dashboardViewController: UIViewController {

    @IBOutlet var btnMyTasks: UIButton!
    @IBOutlet var btnMyTeam: UIButton!
    @IBOutlet var btnNotifications: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var viewStartWorking: UIView!
    @IBOutlet var btnCrossPOPUP: UIButton!
    @IBOutlet var btnSignInOutPOPUP: UIButton!
    @IBOutlet var btnSignInOut2: UIButton!
    var currentUser: User!
    @IBOutlet var btnUserInfo: UIButton!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var sideView: UIView!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var imageSyncMenu: UIImageView!
    @IBOutlet var imagePersonMenu: UIImageView!
    var fromPassCodeView:String!
    @IBOutlet var lblNameSlideMenu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fromPassCodeView != "yes" {
            if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
        
            if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
                
                self.viewStartWorking.alpha = 0
                self.viewStartWorking.hidden = false
                 self.btnSignInOutPOPUP.setTitle("SIGN IN", forState: .Normal)
                self.btnSignInOut2.setTitle("SIGN IN", forState: .Normal)

                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.viewStartWorking.alpha = 1
                    }, completion: nil)
                
                }else{
                self.viewStartWorking.alpha = 0
                self.viewStartWorking.hidden = false
                self.btnSignInOutPOPUP.setTitle("SIGN OUT", forState: .Normal)
                self.btnSignInOut2.setTitle("SIGN OUT", forState: .Normal)

                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.viewStartWorking.alpha = 1
                    }, completion: nil)
                }
            }
        
        }
    }
    override func viewDidDisappear(animated: Bool) {
        btnSetting.backgroundColor = UIColor.clearColor()
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func checkActiveInacive() {
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
            print(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0"  {
        self.btnUserInfo.setImage(UIImage(named: "user_inactive"), forState: .Normal)
         imagePersonMenu.image = UIImage(named: "user_inactive")
        imageSyncMenu.image = UIImage(named: "sync- red")
        }else{
            self.btnUserInfo.setImage(UIImage(named: "user_active"), forState: .Normal)
            imagePersonMenu.image = UIImage(named: "user_active")
            imageSyncMenu.image = UIImage(named: "sync - green")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_FullName")  as? String
        lblNameSlideMenu.text = currentUserName!
        self.checkActiveInacive()
        
        refreshButtonTitleImage()
    }
    
    func refreshButtonTitleImage() {
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
            self.btnSignInOutPOPUP.setTitle("SIGN IN", forState: .Normal)
            self.btnSignInOut2.setTitle("SIGN IN", forState: .Normal)
        }else{
            self.btnSignInOutPOPUP.setTitle("SIGN OUT", forState: .Normal)
            self.btnSignInOut2.setTitle("SIGN OUT", forState: .Normal)
        }
    }
    
    @IBAction func btnMyTasks(sender: AnyObject) {
        btnMyTasks.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
        
        
        
        
    }
    @IBAction func btnMyTeam(sender: AnyObject) {
        btnMyTeam.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTasks.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnNotifications(sender: AnyObject) {
        btnNotifications.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnSetting(sender: AnyObject) {
        btnSetting.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnCrossPOPUP(sender: AnyObject) {
        viewStartWorking.alpha = 1
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.viewStartWorking.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.viewStartWorking.hidden = true
        })
    }

    @IBAction func btnUserInfo(sender: AnyObject) {
    }
    @IBAction func btnSignInOutPOPUP(sender: AnyObject) {
        let buttontitle:String = (btnSignInOutPOPUP.titleLabel!.text)!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dashboardViewController.displayResponse), name: "com.time-em.signInOutResponse", object: nil)
        
      let ActivityId =  NSUserDefaults.standardUserDefaults().valueForKey("currentUser_ActivityId") as! String
    let userId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as! String
     let loginid = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as! String
        
        
        
        if buttontitle.lowercaseString == "sign in" {
            let api = ApiRequest()
            api.signInUser(userId, LoginId: loginid, view: self.view)
        }else{
            let api = ApiRequest()
            
            api.signOutUser(userId, LoginId: loginid, ActivityId: ActivityId, view: self.view)
        }
        
        
    }
    
    @IBAction func btnLogout(sender: AnyObject) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
        try database.executeUpdate("DELETE FROM tasksData", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
         do {
        try database.executeUpdate("DELETE FROM userdata", values: nil )
         } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM teamData", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
        
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLoggedIn")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_id")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_IsSignIn")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_ActivityId")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_LoginId")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_FullName")

        let loginVC: UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("loginView")
        self.presentViewController(loginVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func backgroundButtonOnSlider(sender: AnyObject) {
        self.menuSlideBack()
    }
    func menuSlideBack() {
        UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseIn, animations: {() -> Void in
            //   sideView.hidden=YES;
            var frame: CGRect = self.sideView.frame
            frame.origin.y = self.sideView.frame.origin.y
            frame.origin.x = self.view.frame.origin.x - self.sideView.frame.size.width
            self.sideView.frame = frame
//            var btnmenu_frame: CGRect = self.btnMenu.frame
//            btnmenu_frame.origin.x = self.btnMenu.frame.origin.x - self.sideView.frame.size.width
//            self.btnMenu.frame = btnmenu_frame
            }, completion: {(finished: Bool) -> Void in
                NSLog("Completed")
        })
    }
    @IBAction func btnMenu(sender: AnyObject) {
        if sideView.frame.origin.x == 0 {
            self.menuSlideBack()
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseOut, animations: {() -> Void in
                self.sideView.hidden = false
                var frame: CGRect = self.sideView.frame
                frame.origin.y = self.sideView.frame.origin.y
                frame.origin.x = 0
                self.sideView.frame = frame
//                var btnmenu_frame: CGRect = self.btnMenu.frame
//                btnmenu_frame.origin.x = self.btnMenu.frame.origin.x + self.sideView.frame.size.width
//                self.btnMenu.frame = btnmenu_frame
                }, completion: {(finished: Bool) -> Void in
                    NSLog("Completed")
                    
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myTasksSegue"{
            let mytasks = myTasksViewController()
            mytasks.viewCalledFrom = "myTasks"
        }
    }
    
    func getCurrentUser() {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            let rs = try database.executeQuery("select * from userdata", values: nil)
            while rs.next() {
                let x = rs.stringForColumn("userId")
                let y = rs.dataForColumn("userData")
                let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableDictionary
                print(userDict)
                self.currentUser =  User(dict: userDict)
                
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        
            alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
            
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        viewStartWorking.alpha = 1
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.viewStartWorking.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.viewStartWorking.hidden = true
        })
        self.checkActiveInacive()
        refreshButtonTitleImage()

    }
    
    

}
