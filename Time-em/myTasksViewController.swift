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
    var currentUserID:String! = nil
    
    @IBOutlet var btnSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        self.calendarView = CLWeeklyCalendarView(frame: CGRectMake(0, 0,viewCalanderBackground.frame.size.width, viewCalanderBackground.frame.size.height))
        self.calendarView.delegate = self
        viewCalanderBackground.addSubview(self.calendarView)
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(myTasksViewController.usertasksResponse), name: "com.time-em.usertaskResponse", object: nil)
        
        if currentUserID != nil{
            delay(0.001){
           let height = self.btnSignIn.frame.size.height
        self.btnSignIn.hidden = true
           
                
                print(self.viewCalanderBackground.frame)
            self.viewCalanderBackground.frame = CGRectMake(self.viewCalanderBackground.frame.origin.x, self.viewCalanderBackground.frame.origin.y-height, self.viewCalanderBackground.frame.size.width, self.viewCalanderBackground.frame.size.height)
                print(self.viewCalanderBackground.frame)
                 print(self.tableView.frame)
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-height, self.tableView.frame.size.width, self.tableView.frame.size.height+height)
                print(self.tableView.frame)
            }
            
            self.getDataFromDatabase(currentUserID)
            getuserTask(currentUserID, createdDate: "12-22-2015")
        }else{
        self.getDataFromDatabase("10")
        getuserTask("10", createdDate: "12-22-2015")
        }
        
         tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        
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
    }
    
    func getDataFromDatabase (id:String) {
        let databaseFetch = databaseFile()
      taskDataArray = databaseFetch.getTasksForUserID(id)
     print(taskDataArray)
        tableView.reloadData()
    }
    
    
    func getuserTask(userId:String,createdDate:String){
        let apiCall = ApiRequest()
        if NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") != nil {
        var data: NSData = (NSUserDefaults.standardUserDefaults().objectForKey("taskTimeStamp") as? NSData)!
            var dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            
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
            self.getDataFromDatabase("10")
        }
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

        for view: UIView in UITableViewCell().contentView.subviews {
            if (view is UIView) {
                view.removeFromSuperview()
            }
        }

        let dataDic:NSMutableDictionary = taskDataArray.objectAtIndex(indexPath.row) as! NSMutableDictionary
        
        let notificationImage: UIImageView = UIImageView(frame: CGRectMake(15, 10, 15, 18))
//        notificationImage.image = UIImage(named: "cross-popup")
        notificationImage.backgroundColor = UIColor.yellowColor()
        cell.contentView.addSubview(notificationImage)

        
        let TitleLabel: UILabel = UILabel(frame: CGRectMake(notificationImage.frame.origin.x + notificationImage.frame.size.width + 15, 5, 200 , 30))
        TitleLabel.text = "this is for testing"
        TitleLabel.text =  "\(dataDic.valueForKey("TaskName")!)"
         cell.contentView.addSubview(TitleLabel)

        
        let Description: UILabel = UILabel(frame: CGRectMake(TitleLabel.frame.origin.x, TitleLabel.frame.origin.y + TitleLabel.frame.size.height-10 , 250  + 85  , 58))
        Description.text = "\(dataDic.valueForKey("Comments")!)"
         Description.font  = UIFont(name: "HelveticaNeue", size: 15)
        let lines = Description.getNoOflines()
        if lines > 3 {
            Description.numberOfLines = 3;
        }else{
             Description.autosizeForWidth()
        }
        print(Description.frame.size.height)
        print(lines)
         cell.contentView.addSubview(Description)
        cell.contentView.backgroundColor = UIColor(red: 212/256, green: 212/256, blue: 212/256, alpha: 0.66)
        
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
            self.performSegueWithIdentifier("taskDetail", sender: self)
        }
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func btnSignIn(sender: AnyObject) {
    }
    
}
