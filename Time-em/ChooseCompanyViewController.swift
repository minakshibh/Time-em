//
//  ChooseCompanyViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 23/08/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import JLToast

class ChooseCompanyViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnlabel: UIButton!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var btnlabelheight: NSLayoutConstraint!
    @IBOutlet var logoheight: NSLayoutConstraint!
    
     var fromView:String!
    var companyDataArray:NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hidden = true
        let assignedTasks = ApiRequest()
        let currentUserId = NSUserDefaults.standardUserDefaults() .objectForKey("currentUser_id")
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChooseCompanyViewController.displayResponse), name: "com.time-em.getUserCompaniesList", object: nil)
            assignedTasks.getUserCompaniesList("\(currentUserId!)", view: self.view)

        }else{
            //check if data exist
            if NSUserDefaults.standardUserDefaults().valueForKey("companyData") != nil {
                
                setData()
                
            }else{

            // create the alert
                let alert = UIAlertController(title: "Time'em", message: "Internet connection seems to be offline", preferredStyle: UIAlertControllerStyle.Alert)
            
                alert.addAction(UIAlertAction(title: "Go Back", style: .Default, handler: { action in
                    print("Click of default button")
                    self.dismissViewControllerAnimated(true, completion: {});
                    self.navigationController?.popViewControllerAnimated(true)
                }))
            
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
       
        
        // Do any additional setup after loading the view.
       self.tableView.tableFooterView = UIView()
        
//        tableView.roundCorners([.BottomRight, .BottomLeft], radius: 10)
        delay(0.001){
        self.btnlabel.roundCorners([.TopLeft,.TopRight], radius: 6)
        }
        
        if Reachability.DeviceType.IS_IPHONE_5{
            iphonAdjustments()
        }else if Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
            iphone4Adjustmenr()
        }
    }

    func iphonAdjustments(){
        logoheight.constant = logoheight.constant - 20
        btnlabelheight.constant = btnlabelheight.constant - 20
    }
    func iphone4Adjustmenr(){
        logoheight.constant = logoheight.constant - 20
        btnlabelheight.constant = btnlabelheight.constant - 30
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - Response Function
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.getUserCompaniesList", object:nil)
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            
            setData()
        }else{
            
            view.makeToast("status")
            
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ChooseCompanyViewController.timerFunction), userInfo: nil, repeats: false)
            
            
        }
    }
    
    func setData() {
        let data = NSUserDefaults.standardUserDefaults().valueForKey("companyData") as? NSData
        companyDataArray = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSArray
        if (companyDataArray.count == 1){
            let key:String = "\(companyDataArray[0].valueForKey("Key")!)"
            NSUserDefaults.standardUserDefaults().setObject(key, forKey: "companyKey")
            
            
            delay(0.001){
                self.performSegueWithIdentifier("homeView", sender: self)
            }
            
            
            return
        }
        
        if companyDataArray.count <= 3 {
            if Reachability.DeviceType.IS_IPHONE_5 ||  Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
                self.tableViewHeightConstraint.constant = 50 * CGFloat(self.companyDataArray.count)
            }else{
                self.tableViewHeightConstraint.constant = 70 * CGFloat(self.companyDataArray.count)
            }
            
        }else{
            if Reachability.DeviceType.IS_IPHONE_5 || Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
                self.tableViewHeightConstraint.constant = 50 * 3
            }else{
                self.tableViewHeightConstraint.constant = 70 * 3
            }
        }
        delay(0.001){
            self.tableView.hidden = false
            self.tableView.roundCorners([.BottomRight,.BottomLeft], radius: 6)
        }
        tableView.reloadData()

    }
    
    func timerFunction() {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(companyDataArray == nil)
        {
            return 0
        }
        
        return companyDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }

//        let label = UILabel()
//        label.frame = cell.contentView.frame
//        label.textAlignment = .Center
//        label.text = "\(companyDataArray[indexPath.row].valueForKey("Value")!)"
        
        cell.textLabel?.text = "\(companyDataArray[indexPath.row].valueForKey("Value")!)"
        cell.imageView?.image = UIImage(named: "compnies")
        
        
        cell.selectionStyle = .None
        cell.textLabel!.font = UIFont.systemFontOfSize(20)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let key:String = "\(companyDataArray[indexPath.row].valueForKey("Key")!)"
        NSUserDefaults.standardUserDefaults().setObject(key, forKey: "companyKey")
        
//        var alert :UIAlertController!
//        alert = UIAlertController(title: "Time'em", message: key, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        
        delay(0.001){
        self.performSegueWithIdentifier("homeView", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if Reachability.DeviceType.IS_IPHONE_5{
            return 50
        }else if Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
           return 50
        }
     return 70
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeView"{
            let dash = (segue.destinationViewController as! dashboardViewController)

            if fromView == "fromLogin" {
            dash.fromPassCodeView = "no"
            }else{
            dash.fromPassCodeView = "yes"
            }
        }
    }
    
}
extension UITableView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}
extension UIButton {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}
