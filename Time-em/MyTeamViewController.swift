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
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTeamList() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String

            let api = ApiRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.displayResponse), name: "com.time-em.getTeamResponse", object: nil)
            api.getTeamDetail(logedInUserId!, TimeStamp: "", view: self.view)
    }
    func fetchTeamDataFromDatabase() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String

        var databaseFetch = databaseFile()
        teamDataArray = databaseFetch.getTeamForUserID(logedInUserId!)
        print(teamDataArray)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let dict:NSMutableDictionary  = teamDataArray[indexPath.row] as! NSMutableDictionary
        if "\(dict["IsSignedIn"]!)" == "0" {
         return 50
        }else{
            return 60
        }
        
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
        
        
        if "\(dict["IsNightShift"]!)" == "0" {
            let imageView: UIImageView = UIImageView(image: UIImage(named: "sun"))
            cell.accessoryView = imageView
        }else{
            let imageView: UIImageView = UIImageView(image: UIImage(named: "moon"))
            cell.accessoryView = imageView
        }
        
        if "\(dict["IsSignedIn"]!)" != "0" {
            // create dateFormatter with UTC time format
            if dict["SignInAt"] != nil {
                let str:String!
                if dict["SignInAt"]!.lowercaseString.rangeOfString("t") != nil {
                    str =   "\(dict["SignInAt"]!)".componentsSeparatedByString(".")[0]
                }else{
                 str = "\(dict["SignInAt"]!.componentsSeparatedByString(" ")[0])T\(dict["SignInAt"]!.componentsSeparatedByString(" ")[1])"
                }
                
                
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
            print("\(dict["SignInAt"]!)")
             
            let date: NSDate = dateFormatter.dateFromString(str)!
            // create date from string
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let timestamp: String = dateFormatter.stringFromDate(date)

            cell.detailTextLabel?.text = "SignIn at:- \(timestamp)"
            }
        }
        
        
        
        if "\(dict["IsSignedIn"]!)"  == "0" {
        cell.rightButtons = [MGSwipeButton(title: "Signin",icon:UIImage(named: "SignIn"),backgroundColor: UIColor(red: 23/255, green: 166/255, blue: 199/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("delete: \(indexPath.row)")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.signInOutResponse), name: "com.time-teamUserSignInOutResponse", object: nil)
            let api = ApiRequest()
            api.teamUserSignIn("\(dict["Id"]!)", LoginId: "\(dict["LoginId"]!)", view: self.view)
            
            
            return true
        })]
        }else{
        cell.rightButtons = [MGSwipeButton(title: "Signout",icon:UIImage(named: "SignOut"),backgroundColor: UIColor(red: 23/255, green: 166/255, blue: 199/255, alpha: 1), callback: {
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
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        fetchTeamDataFromDatabase()
    }
    
    @IBAction func btnUserDetail(sender: AnyObject) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myteam_mytask"{
            let mytask = (segue.destinationViewController as! myTasksViewController)
            mytask.currentUserID = selectedUser
            mytask.currentUserFullName = selectedUserFullname
            
        }
    }
    
    func signInOutResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
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
