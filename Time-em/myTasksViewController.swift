//
//  myTasksViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 16/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Toast_Swift

class myTasksViewController: UIViewController,CLWeeklyCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var datePicker: UIDatePicker!
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
    var currentUserActivityId:String! = nil
    var selectedDate:String!
    var selectedTaskData:NSMutableDictionary! = [:]
    var selectededitRowDict:NSMutableDictionary = [:]
    var count:Int = 0
    var webservicehitCount:Int = 0
    var pickerDateStr:String!
    var falagRotation: Bool = false
    
    
    @IBOutlet var btnSignIn: UIButton!
    
    
    @IBOutlet var datepickerView: UIView!
    @IBOutlet var btnShowDatePicker: UIButton!
    @IBAction func btnShowDatePicker(sender: AnyObject) {
        if datepickerView.hidden {
          datepickerView.hidden = false
        }else{
          datepickerView.hidden = true
        }
    }
    @IBAction func datepickerCancel(sender: AnyObject) {
        datepickerView.hidden = true
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "btnShowDatePickertitle")
        btnShowDatePicker.setTitle(" \(selectedDate) ", forState: .Normal)
    }
    @IBAction func datepickerDone(sender: AnyObject) {
        datepickerView.hidden = true
        selectedDate = pickerDateStr
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        //-- setting date view
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        print(dateFormatter.stringFromDate(datePicker.date))
        self.calendarView.redrawToDate(datePicker.date)
        //--
        
        getuserTask(logedInUserId!, createdDate: selectedDate)
        NSUserDefaults.standardUserDefaults().setObject("yes", forKey: "btnShowDatePickertitle")
        self.getDataFromDatabase(logedInUserId!)
        btnShowDatePicker.setTitle(" \(pickerDateStr) ", forState: .Normal)
        
        

    }//rABtqq
    @IBOutlet var datepickerDone: UIButton!
    @IBAction func datePicker(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        print(strDate)
        pickerDateStr = strDate
    }
    
    override func viewDidDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setObject("false", forKey: "isEditingOrAdding")
        btnShowDatePicker.setTitle(" ", forState: .Normal)
        btnShowDatePicker.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btnShowDatePicker.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btnShowDatePicker.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        
        tableView.reloadData()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        pickerDateStr = dateFormatter.stringFromDate(NSDate())
        
        self.dateConversion(NSDate())
        // Do any additional setup after loading the view.
        
        let assignedTasks = ApiRequest()
        
        
//        assignedTasks.GetUserWorksiteActivityGraph("10",view: self.view)
        
        
        
        
//        print(taskDataArray)
        
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        
        
        //        changeSignINButton()
        

        if currentUserID != nil{
            btnAddTask.hidden = true
            btnShowDatePicker.hidden = true
            lblMyTasksHeader.text = currentUserFullName!
            assignedTasks.GetUserWorksiteActivityGraph(currentUserID,view: self.view)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
//            self.getDataFromDatabase(currentUserID)
//            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
//            self.getDataFromDatabase(logedInUserId!)
//            getuserTask(logedInUserId!, createdDate: selectedDate)
            let currentUserId = NSUserDefaults.standardUserDefaults() .objectForKey("currentUser_id")
            assignedTasks.GetAssignedTaskIList(currentUserId as! String, view: self.view)
        }

    }
    func rotated()
    {
        
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:UIViewController = storyboard.instantiateViewControllerWithIdentifier("chart") as! chartViewController
            
            NSUserDefaults.standardUserDefaults().setObject(currentUserID, forKey: "currentUSerID")
            NSUserDefaults.standardUserDefaults().setObject(currentUserFullName, forKey: "currentUserFullName")
        
            self.configureChildViewController(vc, onView: self.view)
            UIApplication.sharedApplication().statusBarHidden=true;
            print("landscape")
            if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft{
                print("chart LandscapeLeft")
            }
            else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight{
                print("my task view chart LandscapeRight")
                
                falagRotation = true
                self.view.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI_2));
                
                
            }

        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            if falagRotation{
                falagRotation=false
            self.view.transform = CGAffineTransformRotate(self.view.transform, -CGFloat(2*M_PI_2));
            }


            print("Portrait")
            if chldViewControllers != nil{
                chldViewControllers.willMoveToParentViewController(nil)
                chldViewControllers.view.removeFromSuperview()
                chldViewControllers.removeFromParentViewController()
                UIApplication.sharedApplication().statusBarHidden=false;
                
            }
        }
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown{
                print("my task view chart PortraitUpsideDown")
        }else{
//            if falagRotation{
//                falagRotation = false
//                //            self.view.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI_2))
//            }
        }
        
    }
    var chldViewControllers:UIViewController!
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        chldViewControllers = childController
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(chldViewControllers)
        holderView.addSubview(chldViewControllers.view)
        chldViewControllers.didMoveToParentViewController(self)
        UIApplication.sharedApplication().statusBarHidden=true;
    }
    func refreshData() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        
        if currentUserID != nil{
            btnAddTask.hidden = true
            lblMyTasksHeader.text = currentUserFullName!
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
            self.getDataFromDatabase(currentUserID)
            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
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
        
        if webservicehitCount != 0 {
            refreshData()
             }
//        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(myTasksViewController.callFunctionView), userInfo: nil, repeats: false)
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
        datepickerView.hidden = true
        print(date)
        let dateStr = "\(date)".componentsSeparatedByString(" ")[0]
        let day = dateStr.componentsSeparatedByString("-")[2]
        let month = dateStr.componentsSeparatedByString("-")[1]
        let year = dateStr.componentsSeparatedByString("-")[0]
        selectedDate = "\(month)-\(day)-\(year)"
        webservicehitCount = 1
        if currentUserID != nil{
            getuserTask(currentUserID, createdDate: selectedDate)
        }else{
            let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
            getuserTask(logedInUserId!, createdDate: selectedDate)
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
            self.getDataFromDatabase(logedInUserId!)
        }
        
//        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
//        self.getDataFromDatabase(logedInUserId!)

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
        
        if         NSUserDefaults.standardUserDefaults().valueForKey("btnShowDatePickertitle") != nil{
            if "\(NSUserDefaults.standardUserDefaults().valueForKey("btnShowDatePickertitle")!)" == "yes"{
            
            }else{
                btnShowDatePicker.setTitle(" ", forState: .Normal)
            }
            

        }

        
        
        
        
        let databaseFetch = databaseFile()
        taskDataArray = databaseFetch.getTasksForUserID(id,Date:selectedDate)
//        print(taskDataArray)
        if taskDataArray.count == 0 {
            NSUserDefaults.standardUserDefaults().setObject("true", forKey: "isEditingOrAdding")
            
//            let alertNoTasks = UIAlertController(title: "Time'em", message: "No tasks available", preferredStyle: UIAlertControllerStyle.Alert)
//            alertNoTasks.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alertNoTasks, animated: true, completion: nil)
//            
//            print(alertNoTasks.title)
//            print(alertNoTasks.message)
        }
        tableView.reloadData()
    }
    
    
    func getuserTask(userId:String,createdDate:String){
        let apiCall = ApiRequest()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") != nil {
            let data: NSData = (NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") as? NSData)!
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            
            if dict.valueForKey(createdDate) != nil {
                TimeStamp = "\(dict.valueForKey(createdDate)!)"
            }else{
                TimeStamp = ""
            }
            
            
        }else{
            TimeStamp = ""
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.usertasksResponse), name: "com.time-em.usertaskResponse", object: nil)
        apiCall.getUserTask(userId, createdDate: createdDate,TimeStamp: TimeStamp, view: self.view)
        
    }

    func usertasksResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
//        var alert :UIAlertController!
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.usertaskResponse", object:nil)
        
        
        
        if status.lowercaseString == "success"{
            
            
            
        }else{
            if status.lowercaseString == "failure" {
                view.makeToast("Failed to get tasks.")
            }else{
                view.makeToast("\(status)")
            }
            

//            alert = UIAlertController(title: "Time'em", message: "\(status)", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        if currentUserID != nil{
//            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
            self.getDataFromDatabase(currentUserID)
        }else{
            let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
//            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
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
            Description.frame = CGRectMake(15,  10 - 10 , 250  + 20  , 58)
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 12.0)!
            Description.font = myFont
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            Description.frame = CGRectMake(15,  10 - 10 , 250  + 50  , 58)
        }else if Reachability.DeviceType.IS_IPAD {
            Description.frame = CGRectMake(15, 10 - 10 , 250  + 85 + 350  , 58)
            
        }
        Description.text =  "\(dataDic.valueForKey("Comments")!)"
        //        Description.text= [notificationDataArr objectAtIndex:indexPath.row];
        Description.font  = UIFont(name: "HelveticaNeue", size: 15)
        if Reachability.DeviceType.IS_IPHONE_5 {
            Description.font  = UIFont(name: "HelveticaNeue", size: 12)
        }
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
        datepickerView.hidden = true
        
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
            TitleLabel.font  = UIFont(name: "HelveticaNeue", size: 15)
        }else if Reachability.DeviceType.IS_IPAD {
            TitleLabel.frame = CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 5, 250 + 85 + 300 , 30)

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
            Description.frame = CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height , 250  + 50  , 58)
            let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 12.0)!
            Description.font = myFont
        }else if Reachability.DeviceType.IS_IPAD {
            Description.frame = CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height , 250  + 85 + 350  , 58)

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
        
        
        let timelabel: UILabel = UILabel(frame: CGRectMake(Description.frame.origin.x + Description.frame.size.width , (Description.frame.size.height + Description.frame.origin.y)/3-5 , 65 , 45))
        timelabel.font  = UIFont(name: "HelveticaNeue", size: 13)
        if Reachability.DeviceType.IS_IPHONE_5 {
            timelabel.frame = CGRectMake(Description.frame.origin.x + Description.frame.size.width-10, TitleLabel.frame.origin.y+3, 60 , 40)
            timelabel.font  = UIFont(name: "HelveticaNeue", size: 10)
        }else if Reachability.DeviceType.IS_IPHONE_6 {
            timelabel.frame = CGRectMake(Description.frame.origin.x + Description.frame.size.width , TitleLabel.frame.origin.y, 65 , 45)
        }
        timelabel.text = "\(roundToPlaces(Double("\(dataDic.valueForKey("TimeSpent")!)")!, places: 2))"
//        timelabel.text =  "\(dataDic.valueForKey("TimeSpent")!)\nhours"
        timelabel.numberOfLines = 2
        timelabel.textAlignment = .Center
        timelabel.textColor = UIColor.blackColor()
//        timelabel.textColor = UIColor(red: 23/256, green: 166/256, blue: 199/256, alpha: 1)
        cell.contentView.addSubview(timelabel)
        
        
        
         let partitionlabel: UILabel = UILabel(frame: CGRectMake(Description.frame.origin.x , Description.frame.origin.y + Description.frame.size.height + 4.5, (timelabel.frame.origin.x + timelabel.frame.size.width/2 ), 1))
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

//            print(dataDic)
            let api = ApiRequest()
            api.deleteTasks("\(dataDic.valueForKey("Id")!)", TimeSpent: "\(dataDic.valueForKey("TimeSpent")!)", CreatedDate: "\(dataDic.valueForKey("CreatedDate")!)", isoffline: "\(dataDic.valueForKey("isoffline")!)", TaskId:"\(dataDic.valueForKey("TaskId")!)", view: self.view)
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
        datepickerView.hidden = true
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.deleteResponse", object:nil)

        if status.lowercaseString == "success"{
            
            
            
        }else{
            
            alert = UIAlertController(title: "Time'em", message: "\(status)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        //        changeSignINButton()
        
        if currentUserID != nil{
//            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
            self.getDataFromDatabase(currentUserID)
        }else{
            let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
//            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "btnShowDatePickertitle")
            self.getDataFromDatabase(logedInUserId!)
        }
    }
    

    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)    }
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
            if currentUserID != nil{
            destinationVC.currentUserID =  currentUserID
            destinationVC.currentUserActivityId = currentUserActivityId
            }
        }
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
}
//
