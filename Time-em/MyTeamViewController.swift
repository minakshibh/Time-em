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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchTeamDataFromDatabase()
        self.fetchTeamList()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        tableView.reloadData()
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
        
        
        if "\(dict["IsNightShift"]!)" == "0" {
            let imageView: UIImageView = UIImageView(image: UIImage(named: "sun"))
            cell.accessoryView = imageView
        }else{
            let imageView: UIImageView = UIImageView(image: UIImage(named: "moon"))
            cell.accessoryView = imageView
        }
        
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict:NSMutableDictionary  = teamDataArray[indexPath.row] as! NSMutableDictionary
        selectedUser =  "\(dict["Id"]!)"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myteam_mytask"{
            let mytask = (segue.destinationViewController as! myTasksViewController)
            mytask.currentUserID = selectedUser
            
            
        }
    }

}
