//
//  MyTeamViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 18/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MyTeamViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tableView: UITableView!
    var teamDataArray:NSMutableArray! = []
    var selectedUser:String!
    var selectedUserFullname:String!
    var fromBarcode:String!
    
    @IBOutlet var btnUserDetail: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.fetchTeamDataFromDatabase()
        self.fetchTeamList()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
            btnUserDetail.setImage(UIImage(named: "user_inactive"), forState: .Normal)
        }else{
            btnUserDetail.setImage(UIImage(named: "user_active"), forState: .Normal)

        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTeamList() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        let timestm:String!
        if NSUserDefaults.standardUserDefaults().valueForKey("teamTimeStamp") != nil {
         timestm = NSUserDefaults.standardUserDefaults().valueForKey("teamTimeStamp") as? String
        }else{
            timestm = ""
        }
            let api = ApiRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.displayResponse), name: "com.time-em.getTeamResponse", object: nil)
            api.getTeamDetail(logedInUserId!, TimeStamp:timestm, view: self.view)
    }
    func fetchTeamDataFromDatabase() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String

        let databaseFetch = databaseFile()
        teamDataArray = databaseFetch.getTeamForUserID(logedInUserId!)
//        print(teamDataArray)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let dict:NSMutableDictionary  = teamDataArray[indexPath.row] as! NSMutableDictionary
        if "\(dict["IsSignedIn"]!)" == "0" {
            if dict["SignInAt"] != nil && dict["SignOutAt"] != nil && "\(dict["SignOutAt"]!)" != "" && "\(dict["SignInAt"]!)" != "" {
                 if Reachability.DeviceType.IS_IPHONE_5 {
                    return 58
                }
                return 60
            }
        }else{
            if Reachability.DeviceType.IS_IPHONE_5 {
                return 43
            }
            return 53
        }
        if Reachability.DeviceType.IS_IPHONE_5 {
            return 43
        }
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        for view: UIView in UITableViewCell().contentView.subviews {
            if (view is UIView) {
                view.removeFromSuperview()
            }
        }
        let dict:NSMutableDictionary  = teamDataArray[indexPath.row] as! NSMutableDictionary

         if "\(dict["IsSignedIn"]!)" == "0" {
             cell.imageView?.image = UIImage(named: "inactive")
         }else{
            cell.imageView?.image = UIImage(named: "active")
        }
        
        cell.textLabel?.text = "\(dict.valueForKey("FullName")!)"
        cell.textLabel?.textColor = UIColor(red: 23/256, green: 166/256, blue: 199/256, alpha: 1)

        if Reachability.DeviceType.IS_IPHONE_5 {
        let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        cell.textLabel?.font = myFont
            
        }

        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        cell.selectionStyle = .None
        
        if "\(dict["IsNightShift"]!)" == "0" {
            let imageView: UIImageView = UIImageView(image: UIImage(named: "sun"))
            cell.accessoryView = imageView
        }else{
            let imageView: UIImageView = UIImageView(image: UIImage(named: "moon"))
            cell.accessoryView = imageView
        }
        
        var finalStrSignInAt:String!
        var finalStrSignOutAt:String!
        
        if "\(dict["IsSignedIn"]!)" != "0" && "\(dict["SignInAt"]!)" != "" {
            // create dateFormatter with UTC time format
            
            if dict["SignInAt"] != nil {
                let str:String!

                let datestr = "\(dict["SignInAt"]!.componentsSeparatedByString(" ")[0])"
                    let dateFormat:String!
                  if datestr.lowercaseString.rangeOfString("/") != nil {
                     dateFormat = "\(datestr.componentsSeparatedByString("/")[2])-\(datestr.componentsSeparatedByString("/")[1])-\(datestr.componentsSeparatedByString("/")[0])"
                  }else{
                    dateFormat = datestr
                    }
                    
                    
                    
                 str = "\(dateFormat)T\(dict["SignInAt"]!.componentsSeparatedByString(" ")[1])"

                
                
//            let dateFormatter: NSDateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
//            print("\(dict["SignInAt"]!)")
//             
//            let date: NSDate = dateFormatter.dateFromString(str)!
//            // create date from string
//            // change to a readable time format and change to local time zone
//            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
//            dateFormatter.timeZone = NSTimeZone.localTimeZone()
//            let timestamp: String = dateFormatter.stringFromDate(date)

//            cell.detailTextLabel?.text = "In:- \(timestamp)"
             cell.detailTextLabel?.text =  "In:- \(dict["SignInAt"]!)"
              if  Reachability.DeviceType.IS_IPHONE_5 {
                let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 10.0)!
                cell.detailTextLabel?.font = myFont
                
              }else if Reachability.DeviceType.IS_IPHONE_6 {
                cell.detailTextLabel?.frame = CGRectMake((cell.detailTextLabel?.frame.origin.x)!, (cell.detailTextLabel?.frame.origin.y)!, (cell.detailTextLabel?.frame.size.width)!+150, (cell.detailTextLabel?.frame.size.height)!+25)
                }
                cell.detailTextLabel?.numberOfLines = 2
            }
        }else{
            if dict["SignInAt"] != nil && "\(dict["SignInAt"]!)" != ""{
                let str:String!
//                if dict["SignInAt"]!.lowercaseString.rangeOfString("t") != nil {
//                    str =   "\(dict["SignInAt"]!)".componentsSeparatedByString(".")[0]
//                }else{
//                    //   24/05/2016 07:27:45
//                    let datestr = "\(dict["SignInAt"]!.componentsSeparatedByString(" ")[0])"
//                    let dateFormat:String!
//                    if datestr.lowercaseString.rangeOfString("/") != nil {
//                        dateFormat = "\(datestr.componentsSeparatedByString("/")[2])-\(datestr.componentsSeparatedByString("/")[1])-\(datestr.componentsSeparatedByString("/")[0])"
//                    }else{
//                        dateFormat = datestr
//                    }
//                    
//                    
//                    
//                    str = "\(dateFormat)T\(dict["SignInAt"]!.componentsSeparatedByString(" ")[1])"
////                }
//                
//                
//                let dateFormatter: NSDateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
//                print("\(dict["SignInAt"]!)")
//                
//                let date: NSDate = dateFormatter.dateFromString(str)!
//                // create date from string
//                // change to a readable time format and change to local time zone
//                dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
//                dateFormatter.timeZone = NSTimeZone.localTimeZone()
//                let timestamp: String = dateFormatter.stringFromDate(date)
//                
//                finalStrSignInAt = "In:- \(timestamp)"
                finalStrSignInAt = "In:- \(dict["SignInAt"]!)"
            }
            //---
            if dict["SignInAt"] != nil && dict["SignOutAt"] != nil && "\(dict["SignOutAt"]!)" != "" && "\(dict["SignInAt"]!)" != ""{
                let str:String!
                if dict["SignOutAt"]!.lowercaseString.rangeOfString("t") != nil {
                    str =   "\(dict["SignOutAt"]!)".componentsSeparatedByString(".")[0]
                }else{
                    let datestr = "\(dict["SignOutAt"]!.componentsSeparatedByString(" ")[0])"
                    let dateFormat = datestr
                    
//                    str = "\(dateFormat)T\(dict["SignOutAt"]!.componentsSeparatedByString(" ")[1])"
                    str = "\(dict["SignOutAt"]!)"
                }
//                let dateFormatter: NSDateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
//                print("\(dict["SignOutAt"]!)")
//                
//                let date: NSDate = dateFormatter.dateFromString(str)!
//                // create date from string
//                // change to a readable time format and change to local time zone
//                dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
//                dateFormatter.timeZone = NSTimeZone.localTimeZone()
//                let timestamp: String = dateFormatter.stringFromDate(date)
                
//                finalStrSignOutAt = "Out- \(timestamp)"
                finalStrSignOutAt = "Out- \(str)"
                
            }
            if finalStrSignInAt != nil && finalStrSignOutAt != nil {
            cell.detailTextLabel?.text = "\(finalStrSignInAt)\n\(finalStrSignOutAt)"
            if  Reachability.DeviceType.IS_IPHONE_5 {
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 10.0)!
                cell.detailTextLabel?.font = myFont
            }else if Reachability.DeviceType.IS_IPHONE_6 {
                cell.detailTextLabel?.frame = CGRectMake((cell.detailTextLabel?.frame.origin.x)!, (cell.detailTextLabel?.frame.origin.y)!, (cell.detailTextLabel?.frame.size.width)!+150, (cell.detailTextLabel?.frame.size.height)!+25)
                let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 10.0)!
                cell.detailTextLabel?.font = myFont

            }
            cell.detailTextLabel?.numberOfLines = 2
            }
        }
        
        
        
        if "\(dict["IsSignedIn"]!)"  == "0" {
        cell.rightButtons = [MGSwipeButton(title: "  Signin  ",icon:UIImage(named: ""),backgroundColor: UIColor(red: 23/255, green: 166/255, blue: 199/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("delete: \(indexPath.row)")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.signInOutResponse), name: "com.time-teamUserSignInOutResponse", object: nil)
            let api = ApiRequest()
            api.teamUserSignIn("\(dict["Id"]!)", LoginId: "\(dict["LoginId"]!)", view: self.view)
            
            
            return true
        })]
        }else{
        cell.rightButtons = [MGSwipeButton(title: "  Signout  ",icon:UIImage(named: ""),backgroundColor: UIColor(red: 23/255, green: 166/255, blue: 199/255, alpha: 1), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("delete: \(indexPath.row)")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.signInOutResponse), name: "com.time-teamUserSignInOutResponse", object: nil)
            let api = ApiRequest()
            api.teamUserSignOut("\(dict["Id"]!)", LoginId: "\(dict["LoginId"]!)", ActivityId: "\(dict["ActivityId"]!)", view: self.view)
            
                return true
            })]
        }

        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict:NSMutableDictionary  = teamDataArray[indexPath.row] as! NSMutableDictionary
        selectedUser =  "\(dict["Id"]!)"
        selectedUserFullname = "\(dict["FullName"]!)"
        self.performSegueWithIdentifier("myteam_mytask", sender: self)
    }
    
    
    @IBAction func btnBack(sender: AnyObject) {
        if fromBarcode != nil {
            if fromBarcode == "true" {
                self.performSegueWithIdentifier("teamTodashboard", sender: self)
                
                return
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.getTeamResponse", object:nil)

        var alert :UIAlertController!
        alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        fetchTeamDataFromDatabase()
    }
    
    @IBAction func btnUserDetail(sender: AnyObject) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myteam_mytask"{
            let mytask = (segue.destinationViewController as! myTasksViewController)
            mytask.currentUserID = selectedUser
            mytask.currentUserFullName = selectedUserFullname
            
        }else if segue.identifier == "teamTodashboard"{
            let dash = (segue.destinationViewController as! dashboardViewController)
            
            
        }
        
    }
    
    func signInOutResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!

        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-teamUserSignInOutResponse", object:nil)

        //        if status.lowercaseString == "success"{
//            alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
//            self.performSegueWithIdentifier("homeView", sender: self)
//            
//        }else{
//            alert = UIAlertController(title: "Time'em", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
//        }
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        fetchTeamDataFromDatabase()
    }

}
