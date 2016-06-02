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
    @IBOutlet var btnAddTask: UIButton!
    var currentUserID:String! = nil
    var currentUserFullName:String! = nil
    var selectedDate:String!
    var selectedTaskData:NSMutableDictionary! = [:]
    var selectededitRowDict:NSMutableDictionary = [:]
    var count:Int = 0
    
    @IBOutlet var btnSignIn: UIButton!
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateConversion(NSDate())
        // Do any additional setup after loading the view.
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.usertasksResponse), name: "com.time-em.usertaskResponse", object: nil)
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        
        
        //        changeSignINButton()
        
    }
    
    func refreshData() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        
        
        
        if currentUserID != nil{
            btnAddTask.hidden = true
            lblMyTasksHeader.text = currentUserFullName!
            self.getDataFromDatabase(currentUserID)
            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
            self.getDataFromDatabase(logedInUserId!)
            getuserTask(logedInUserId!, createdDate: selectedDate)
        }
    }
    
    
    func iphone5UiAdjustments() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if count == 0 {
            count += 1
        self.calendarView = CLWeeklyCalendarView(frame: CGRectMake(0, 0,viewCalanderBackground.frame.size.width, viewCalanderBackground.frame.size.height))
        self.calendarView.delegate = self
        viewCalanderBackground.addSubview(self.calendarView)
        }
        
        if Reachability.DeviceType.IS_IPHONE_5 {
            iphone5UiAdjustments()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshData()
        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(myTasksViewController.callFunctionView), userInfo: nil, repeats: false)
    }
    
    func callFunctionView() {
       
    }
    
    func changeSignINButton()  {
        let isCurrentUserSignIn = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")! as? String
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
        
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        self.getDataFromDatabase(logedInUserId!)

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
        taskDataArray = databaseFetch.getTasksForUserID(id,Date:selectedDate)
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
        
        apiCall.getUserTask(userId, createdDate: createdDate,TimeStamp: TimeStamp, view: self.view)
        
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
        let Description: UILabel = UILabel(frame: CGRectMake(15, 0, 250+85 , 58))
        if Reachability.DeviceType.IS_IPHONE_5 {
            Description.frame = CGRectMake(15,  10 - 10 , 250  + 30  , 58)
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 12.0)!
            Description.font = myFont
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            Description.frame = CGRectMake(15,  10 - 10 , 250  + 50  , 58)
        }
        Description.text =  "\(dataDic.valueForKey("Comments")!)"
        //        Description.text= [notificationDataArr objectAtIndex:indexPath.row];
        Description.font  = UIFont(name: "HelveticaNeue", size: 15)
        let lines = Description.getNoOflines()
        if lines > 3 {
            if Reachability.DeviceType.IS_IPHONE_5 {
                return 89
            }
            return 93
        }else{
            Description.autosizeForWidth()
            print(Description.frame.size.height)
            if Reachability.DeviceType.IS_IPHONE_5 {
                return Description.frame.size.height + 30
            }
            return Description.frame.size.height + 41
            
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
        
        let notificationImage: UIImageView = UIImageView(frame: CGRectMake(0, 10, 0, 18))
        //        notificationImage.image = UIImage(named: "cross-popup")
        //        notificationImage.backgroundColor = UIColor.yellowColor()
        cell.contentView.addSubview(notificationImage)
        
        
        let TitleLabel: UILabel = UILabel(frame: CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 5, 250 + 85 , 30))
         TitleLabel.font  = UIFont(name: "HelveticaNeue", size: 15  )
        if Reachability.DeviceType.IS_IPHONE_5 {
            TitleLabel.frame = CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 0, 250  , 30)
             TitleLabel.font  = UIFont(name: "HelveticaNeue", size: 15)
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            TitleLabel.frame = CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 5, 250 + 50 , 30)
        }
        TitleLabel.text =  "\(dataDic.valueForKey("TaskName")!)"
        TitleLabel.textColor = UIColor(red: 23/256, green: 166/256, blue: 199/256, alpha: 1)
        cell.contentView.addSubview(TitleLabel)
        
        
        let Description: UILabel = UILabel(frame: CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height , 250  + 85  , 58))
        Description.text = "\(dataDic.valueForKey("Comments")!)"
        Description.font  = UIFont(name: "HelveticaNeue", size: 15)
        Description.textColor = UIColor.darkGrayColor()
        if Reachability.DeviceType.IS_IPHONE_5 {
            Description.frame = CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height-5 , 250  + 20  , 58)
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 12.0)!
            Description.font = myFont
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            Description.frame = CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height-10 , 250  + 50  , 58)
        }
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
        cell.selectionStyle = .None
        
        
        let timelabel: UILabel = UILabel(frame: CGRectMake(Description.frame.origin.x + Description.frame.size.width , (Description.frame.size.height + Description.frame.origin.y)/3 , 65 , 45))
        timelabel.font  = UIFont(name: "HelveticaNeue", size: 13)
        if Reachability.DeviceType.IS_IPHONE_5 {
            timelabel.frame = CGRectMake(Description.frame.origin.x + Description.frame.size.width-10, TitleLabel.frame.origin.y+3, 60 , 40)
            timelabel.font  = UIFont(name: "HelveticaNeue", size: 10)
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            timelabel.frame = CGRectMake(Description.frame.origin.x + Description.frame.size.width , TitleLabel.frame.origin.y, 65 , 45)
        }
        timelabel.text =  "\(dataDic.valueForKey("TimeSpent")!)\nhours"
        timelabel.numberOfLines = 2
        timelabel.textAlignment = .Center
        timelabel.textColor = UIColor.blackColor()
//        timelabel.textColor = UIColor(red: 23/256, green: 166/256, blue: 199/256, alpha: 1)
        cell.contentView.addSubview(timelabel)
        
        
        
         let partitionlabel: UILabel = UILabel(frame: CGRectMake(Description.frame.origin.x , Description.frame.origin.y + Description.frame.size.height + 4.5 + 2, (timelabel.frame.origin.x + timelabel.frame.size.width/2 ), 1))
        partitionlabel.backgroundColor = UIColor(red: 215/256, green: 215/256, blue: 215/256, alpha: 1)

         if lines > 3 {
            partitionlabel.frame = CGRectMake(partitionlabel.frame.origin.x, partitionlabel.frame.origin.y-2, partitionlabel.frame.size.width, partitionlabel.frame.size.height)
        }
        cell.contentView.addSubview(partitionlabel)
//        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"edit"), backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1))
//            ,MGSwipeButton(title: "", icon: UIImage(named:"delete"), backgroundColor:UIColor(red: 209/255, green: 25/255, blue: 16/255, alpha: 1))]
//        cell.leftSwipeSettings.transition = MGSwipeTransition.Static
        
        cell.rightButtons = [MGSwipeButton(title: "",icon:UIImage(named: "delete"),backgroundColor: UIColor(red: 209/255, green: 25/255, blue: 16/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("delete: \(indexPath.row)")
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.deleteTaskResponse), name: "com.time-em.deleteResponse", object: nil)

            print(dataDic)
            let api = ApiRequest()
            api.deleteTasks("\(dataDic.valueForKey("Id")!)", view: self.view)
            
            return true
        }),MGSwipeButton(title: "", icon:UIImage(named: "edit"),backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("edit: \(indexPath.row)")
//            delay(0.001){
//                let dataDic:NSMutableDictionary = self.taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
                self.selectededitRowDict = self.taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
            
            self.performSegueWithIdentifier("editNewTask", sender: self)
            
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                
//                let AddNewTaskView = storyBoard.instantiateViewControllerWithIdentifier("AddNewTaskIdentifier") as! AddNewTaskViewController
//                AddNewTaskView.editTaskDict = dataDic
//                AddNewTaskView.isEditting = "true"
//                self.presentViewController(AddNewTaskView, animated:false, completion:nil)
//            }
            
            
            
            
            
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
    
    func deleteTaskResponse(notification:NSNotification) {
        
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
        
        if currentUserID != nil{
            self.getDataFromDatabase(currentUserID)
        }else{
            let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
            self.getDataFromDatabase(logedInUserId!)
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
        } else if segue.identifier == "addNewTask"{
            
            let destinationVC = segue.destinationViewController as! AddNewTaskViewController
            destinationVC.isEditting = "false"
            destinationVC.createdDate = self.selectedDate
        }else if segue.identifier == "editNewTask"{
            let destinationVC = segue.destinationViewController as! AddNewTaskViewController
            destinationVC.editTaskDict = selectededitRowDict
            destinationVC.isEditting = "true"
        }
    }
    
    
}
//