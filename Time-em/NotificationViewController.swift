//
//  NotificationViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 27/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotificationViewController: UIViewController {

    
    @IBOutlet var dateTimeLbl: UILabel!
    @IBOutlet var notificationBtn: UIButton!
    @IBOutlet var messagesBtn: UIButton!
    @IBOutlet var viewsBtn: UIButton!
    @IBOutlet var notificationsTableView: UITableView!
    let normalColor = UIColor(red: 32/255, green: 44/255, blue: 66/255, alpha: 1)
    let highLightedColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
    var notificationsListArray :NSArray! = []
    var allNotificationsListArray :NSMutableArray! = []

    var notificationType : NSString! = "notify"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        self.fetchNotificationDataFromDatabase()
        self.fetchNotificationList()
        notificationBtn.backgroundColor = highLightedColor
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.dateConversion(NSDate())

        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNotificationList() {
        
        let userid = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        
        let timestm:String!
        if NSUserDefaults.standardUserDefaults().valueForKey("notificationsTimeStamp") != nil {
            timestm = NSUserDefaults.standardUserDefaults().valueForKey("notificationsTimeStamp") as? String
        }else{
            timestm = ""
        }
        let api = ApiRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayResponse), name: "com.time-em.getNotificationListByLoginCode", object: nil)
        api.getNotifications(userid!, timeStamp: timestm)
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        //        self.presentViewController(alert, animated: true, completion: nil)
        fetchNotificationDataFromDatabase()
    }

    func fetchNotificationDataFromDatabase() {
        let databaseFetch = databaseFile()
        allNotificationsListArray = databaseFetch.getNotifications()
        print(allNotificationsListArray)
        self.showNotificationsInTable()
    }
    
    func showNotificationsInTable() {
        let predicate = NSPredicate(format: "SELF contains %@", notificationType)
        notificationsListArray = allNotificationsListArray.filter { predicate.evaluateWithObject($0) }
        print(notificationsListArray)
        self.notificationsTableView.reloadData()
    }

    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func viewsBtn(sender: AnyObject) {
        notificationType = "view"
        viewsBtn.backgroundColor = highLightedColor
        notificationBtn.backgroundColor = normalColor
        messagesBtn.backgroundColor = normalColor
        self.showNotificationsInTable()
    }
    @IBAction func notificationsBtn(sender: AnyObject) {
        notificationType = "notify"
        viewsBtn.backgroundColor = normalColor
        notificationBtn.backgroundColor = highLightedColor
        messagesBtn.backgroundColor = normalColor
        self.showNotificationsInTable()

    }
    @IBAction func messagesBtn(sender: AnyObject) {
        notificationType = "Message"
        viewsBtn.backgroundColor = normalColor
        notificationBtn.backgroundColor = normalColor
        messagesBtn.backgroundColor = highLightedColor
        self.showNotificationsInTable()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if Reachability.DeviceType.IS_IPHONE_5 {
            return 40
        }
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.notificationsTableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        cell.backgroundColor = UIColor.clearColor()
        let dict:NSMutableDictionary  = notificationsListArray[indexPath.row] as! NSMutableDictionary
        
        if dict.valueForKey("SenderFullName") is NSNull
        {
            cell.textLabel?.text = ""
        }
        else{
            cell.textLabel?.text = "\(dict.valueForKey("SenderFullName")!)"
        }
        
        if Reachability.DeviceType.IS_IPHONE_5 {
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 14.0)!
            cell.textLabel?.font = myFont
        }
        
        cell.selectionStyle = .None
        
        cell.rightButtons = [MGSwipeButton(title: "",icon:UIImage(named: "delete"),backgroundColor: UIColor(red: 209/255, green: 25/255, blue: 16/255, alpha: 1), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("delete: \(indexPath.row)")
                //Delete query
                let databse = databaseFile()
                databse.deleteNotification("\(dict.valueForKey("NotificationId")!)")
                self.fetchNotificationDataFromDatabase()
            
                return true
            })]
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict:NSMutableDictionary  = notificationsListArray[indexPath.row] as! NSMutableDictionary
//        selectedUser =  "\(dict["Id"]!)"
//        selectedUserFullname = "\(dict["FullName"]!)"
//        self.performSegueWithIdentifier("myteam_mytask", sender: self)
    }

    
    func dateConversion (date:NSDate) {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(date)
        
        dateTimeLbl.text = dateStr
        
    }

}
