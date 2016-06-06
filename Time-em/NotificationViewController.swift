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
    var selectedNotificationData:NSMutableDictionary! = [:]

    
    let normalColor = UIColor(red: 32/255, green: 44/255, blue: 66/255, alpha: 1)
    let highLightedColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
    let fontSmall: UIFont = UIFont(name: "HelveticaNeue", size: 11.0)!
    let font: UIFont = UIFont(name: "HelveticaNeue", size: 15.0)!

    var notificationsListArray :NSArray! = []
    var allNotificationsListArray :NSMutableArray! = []

    var notificationType : NSString! = "Notice"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        self.fetchNotificationDataFromDatabase()
        self.fetchNotificationList()
        notificationBtn.backgroundColor = highLightedColor
        
        // Do any additional setup after loading the view.
        main {
            let api = ApiRequest()
            api.GetNotificationType()
            
            let userIdStr = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
            let TimeStamp:String!
            if NSUserDefaults.standardUserDefaults().objectForKey("activeUserListTimeStamp") != nil {
                TimeStamp = NSUserDefaults.standardUserDefaults().objectForKey("activeUserListTimeStamp") as? String
            }else{
                TimeStamp = ""
            }
            api.getActiveUserList(userIdStr!,timeStamp:TimeStamp)
        }
    }
    override func viewWillAppear(animated: Bool) {
         dateTimeLbl.text = self.dateConversion(NSDate()) as String
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
        notificationType = "File"
        viewsBtn.backgroundColor = highLightedColor
        notificationBtn.backgroundColor = normalColor
        messagesBtn.backgroundColor = normalColor
        self.showNotificationsInTable()
    }
    @IBAction func notificationsBtn(sender: AnyObject) {
        notificationType = "Notice"
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
        return 78
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
        for object: AnyObject in cell.contentView.subviews {
            object.removeFromSuperview()
        }
        
        cell.backgroundColor = UIColor.clearColor()
        let dict:NSMutableDictionary  = notificationsListArray[indexPath.row] as! NSMutableDictionary
        cell.selectionStyle = .None
        
        
        let senderNameLabel: UILabel = UILabel(frame: CGRectZero)
        let TitleLabel: UILabel = UILabel(frame: CGRectZero)
        let DescriptionLabel: UILabel = UILabel(frame: CGRectZero)
        let dateTimelabel: UILabel = UILabel(frame: CGRectZero)
        
        if dict.valueForKey("SenderFullName") is NSNull
        {
            senderNameLabel.text = ""
        }
        else{
            senderNameLabel.text = "\(dict.valueForKey("SenderFullName")!)"
        }
        senderNameLabel.textColor = UIColor(red: 23/256, green: 166/256, blue: 199/256, alpha: 1)
        cell.contentView.addSubview(senderNameLabel)
        
        
        TitleLabel.font  = font
        if dict.valueForKey("Subject") is NSNull
        {
            TitleLabel.text = ""
        }
        else{
            TitleLabel.text = "\(dict.valueForKey("Subject")!)"
        }
        TitleLabel.textColor = UIColor.blackColor()
        cell.contentView.addSubview(TitleLabel)

        
        if dict.valueForKey("Message") is NSNull
        {
            DescriptionLabel.text = ""
        }
        else{
            DescriptionLabel.text = "\(dict.valueForKey("Message")!)"
        }
        DescriptionLabel.font  = font
        DescriptionLabel.textColor = UIColor.darkGrayColor()
        cell.contentView.addSubview(DescriptionLabel)
        
        cell.selectionStyle = .None
        
        var dateStr: String = ""
        
        if dict.valueForKey("createdDate") is NSNull
        {
            dateTimelabel.text = ""
        }
        else{
            dateStr = "\(dict.valueForKey("createdDate")!)"
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let date: NSDate = dateFormatter.dateFromString(dateStr)!
            let currentDate: NSDate = NSDate()
            
            
//            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.stringFromDate(date)
            let date2String = dateFormatter.stringFromDate(currentDate)
            if date1String == date2String {
                dateFormatter.dateFormat = "HH:mm"
                dateStr = dateFormatter.stringFromDate(date)
            }
            else{
                dateStr = self.dateConversion(date) as String
            }
            dateTimelabel.text = dateStr as String
        }
        
        
        dateTimelabel.font  = fontSmall
        dateTimelabel.numberOfLines = 1
        dateTimelabel.textAlignment = .Center
        dateTimelabel.textColor = UIColor.blackColor()
        cell.contentView.addSubview(dateTimelabel)
        
        let frame : CGRect = self.view!.frame
        let padding: CGFloat = 8
        let dateTimeLblWidth: CGFloat = 90
        let Xposition: CGFloat = 20
        let labelHeight : CGFloat = 30
        let labelWidth : CGFloat = frame.width - (dateTimeLblWidth+padding*2 + Xposition)


        senderNameLabel.frame = CGRectMake(padding, padding, labelWidth, labelHeight)
        TitleLabel.frame = CGRectMake(padding, labelHeight - 4 , labelWidth, labelHeight)
        DescriptionLabel.frame = CGRectMake(padding, labelHeight*2 - 13 , labelWidth, labelHeight)
        dateTimelabel.frame = CGRectMake(frame.width - (dateTimeLblWidth + padding), TitleLabel.frame.origin.y, dateTimeLblWidth,labelHeight)
     
        
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
            delay(0.001){
                let dict:NSMutableDictionary  = self.notificationsListArray[indexPath.row] as! NSMutableDictionary
                self.selectedNotificationData = dict
                self.performSegueWithIdentifier("notificationDetail", sender: self)
            }
        
        
//        selectedUser =  "\(dict["Id"]!)"
//        selectedUserFullname = "\(dict["FullName"]!)"
//        self.performSegueWithIdentifier("myteam_mytask", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "notificationDetail"{
            let nDetail = (segue.destinationViewController as! NotificationDetailViewController)
            nDetail.notificationData = self.selectedNotificationData
        }
    }

    func dateConversion(date : NSDate) -> NSString {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
//    func dateConversion (date:NSDate) {
//        
//        let dateFormatter: NSDateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEE d MMM,yyyy"
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        let dateStr: String = dateFormatter.stringFromDate(date)
//        
//        dateTimeLbl.text = dateStr
//        
//    }

}
