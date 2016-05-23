//
//  myTasksViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 16/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class myTasksViewController: UIViewController,CLWeeklyCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate {

     var calendarView: CLWeeklyCalendarView!
    @IBOutlet var viewCalanderBackground: UIView!
    @IBOutlet var tableView: UITableView!
    var viewCalledFrom:String!
    var TimeStamp:String!
    var taskDataArray:NSMutableArray! = []
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblMyTasksHeader: UILabel!
    var currentUserID:String! = nil
    var currentUserFullName:String! = nil
    var selectedDate:String!
    var selectedTaskData:NSMutableDictionary! = [:]
    
    @IBOutlet var btnSignIn: UIButton!
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateConversion(NSDate())
        // Do any additional setup after loading the view.
        
        self.calendarView = CLWeeklyCalendarView(frame: CGRectMake(0, 0,viewCalanderBackground.frame.size.width, viewCalanderBackground.frame.size.height))
        self.calendarView.delegate = self
        viewCalanderBackground.addSubview(self.calendarView)
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.usertasksResponse), name: "com.time-em.usertaskResponse", object: nil)
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String

        
        
        if currentUserID != nil{
             lblMyTasksHeader.text = currentUserFullName!
            self.getDataFromDatabase(currentUserID)
            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
        self.getDataFromDatabase(logedInUserId!)
        getuserTask(logedInUserId!, createdDate: selectedDate)
        }
        
         tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        
       
//        changeSignINButton()
        
    }
    
    func changeSignINButton()  {
        var isCurrentUserSignIn = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")! as? String
        if isCurrentUserSignIn == "0" {
            btnSignIn.setTitle("Signin", forState: .Normal)
            btnSignIn.setImage(UIImage(named: "SignIn"), forState: .Normal)
        }else{
            btnSignIn.setTitle("Signout", forState: .Normal)
            btnSignIn.setImage(UIImage(named: "SignOut"), forState: .Normal)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject] {
        return [:]
    }
    
    func dailyCalendarViewDidSelect(date: NSDate) {
        print(date)
        let dateStr = "\(date)".componentsSeparatedByString(" ")[0]
        let day = dateStr.componentsSeparatedByString("-")[2]
        let month = dateStr.componentsSeparatedByString("-")[1]
        let year = dateStr.componentsSeparatedByString("-")[0]
        selectedDate = "\(month)-\(day)-\(year)"
        if currentUserID != nil{
            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
         let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
           getuserTask(logedInUserId!, createdDate: selectedDate)
        }

        //12-22-2015
    }
    func dateConversion (date:NSDate) {
        let dateStr = "\(date)".componentsSeparatedByString(" ")[0]
        let day = dateStr.componentsSeparatedByString("-")[2]
        let month = dateStr.componentsSeparatedByString("-")[1]
        let year = dateStr.componentsSeparatedByString("-")[0]
        
        selectedDate = "\(month)-\(day)-\(year)"
        
    }
    
    
    func getDataFromDatabase (id:String) {
        let databaseFetch = databaseFile()
      taskDataArray = databaseFetch.getTasksForUserID("10")
     print(taskDataArray)
        tableView.reloadData()
    }
    
    
    func getuserTask(userId:String,createdDate:String){
        let apiCall = ApiRequest()
        if NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") != nil {
        let data: NSData = (NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") as? NSData)!
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            
            if dict.valueForKey(userId) != nil {
              TimeStamp = "\(dict.valueForKey(userId)!)"
            }else{
                TimeStamp = ""
            }
            

        }else{
             TimeStamp = ""
        }
        
    apiCall.getUserTask("10", createdDate: "12-22-2015",TimeStamp: TimeStamp, view: self.view)
        
    }
    
    func usertasksResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            
            
            
        }else{
            
            alert = UIAlertController(title: "Time'em", message: "\(status)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        if currentUserID != nil{
            self.getDataFromDatabase(currentUserID)
        }else{
             let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
            self.getDataFromDatabase(logedInUserId!)
        }
    }
    func signInOutResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            
            
            
        }else{
            
            alert = UIAlertController(title: "Time'em", message: "\(status)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
//        changeSignINButton()
        
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let dataDic:NSMutableDictionary = taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
        var Description: UILabel = UILabel(frame: CGRectMake(15, 0, 250+85 , 58))
        Description.text =  "\(dataDic.valueForKey("Comments")!)"
        //        Description.text= [notificationDataArr objectAtIndex:indexPath.row];
         Description.font  = UIFont(name: "HelveticaNeue", size: 15)
       let lines = Description.getNoOflines()
        if lines > 3 {
            return 100
        }else{
           Description.autosizeForWidth()
            print(Description.frame.size.height)
            return Description.frame.size.height + 30
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }

        for view: UIView in cell.contentView.subviews {
            if (view is UILabel) {
                view.removeFromSuperview()
            }
        }

        let dataDic:NSMutableDictionary = taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
        
        let notificationImage: UIImageView = UIImageView(frame: CGRectMake(15, 10, 0, 18))
//        notificationImage.image = UIImage(named: "cross-popup")
//        notificationImage.backgroundColor = UIColor.yellowColor()
        cell.contentView.addSubview(notificationImage)

        
        let TitleLabel: UILabel = UILabel(frame: CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 5, 200 , 30))
        TitleLabel.text = "this is for testing"
        TitleLabel.text =  "\(dataDic.valueForKey("TaskName")!)"
         TitleLabel.font  = UIFont(name: "HelveticaNeue", size: 17)
         cell.contentView.addSubview(TitleLabel)

        
        let Description: UILabel = UILabel(frame: CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height-10 , 250  + 85  , 58))
        Description.text = "\(dataDic.valueForKey("Comments")!)"
         Description.font  = UIFont(name: "HelveticaNeue", size: 15)
        Description.textColor = UIColor.darkGrayColor()
        let lines = Description.getNoOflines()
        if lines > 3 {
            Description.numberOfLines = 3;
        }else{
             Description.autosizeForWidth()
        }
        print(Description.frame.size.height)
        print(lines)
         cell.contentView.addSubview(Description)
        cell.contentView.backgroundColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1)
        
        
        
        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"edit"), backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1))
            ,MGSwipeButton(title: "", icon: UIImage(named:"delete"), backgroundColor:UIColor(red: 209/255, green: 25/255, blue: 16/255, alpha: 1))]
        cell.leftSwipeSettings.transition = MGSwipeTransition.Static
        
        cell.rightButtons = [MGSwipeButton(title: "",icon:UIImage(named: "delete"),backgroundColor: UIColor(red: 209/255, green: 25/255, blue: 16/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("delete: \(indexPath.row)")
            
            return true
        }),MGSwipeButton(title: "", icon:UIImage(named: "edit"),backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("edit: \(indexPath.row)")
            
            
            return true
        })]
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delay(0.001){
            let dataDic:NSMutableDictionary = self.taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
            self.selectedTaskData = dataDic
            self.performSegueWithIdentifier("taskDetail", sender: self)
        }
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func btnSignIn(sender: AnyObject) {
        let buttontitle:String = (btnSignIn.titleLabel!.text)!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.signInOutResponse), name: "com.time-em.signInOutResponse", object: nil)
        
        let ActivityId =  NSUserDefaults.standardUserDefaults().valueForKey("currentUser_ActivityId") as! String
        let userId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as! String
        let loginid = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as! String
        
        
        
        if buttontitle.lowercaseString == "signin" {
            let api = ApiRequest()
            api.signInUser(userId, LoginId: loginid, view: self.view)
        }else{
            let api = ApiRequest()
            
            api.signOutUser(userId, LoginId: loginid, ActivityId: ActivityId, view: self.view)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "taskDetail"{
            let taskDetail = (segue.destinationViewController as! TaskDetailViewController)
            taskDetail.taskData = self.selectedTaskData
            
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as! AddNewTaskViewController
        destinationVC.createdDate = self.selectedDate
    }


}
