//
//  BarcodeDetailViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 26/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class BarcodeDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var scannedBarcodeArr:NSMutableArray = []
    var dataArray:NSMutableArray = []
    @IBOutlet var btnback: UIButton!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var tableView: UITableView!
    var noDataObjects:NSMutableArray = []
    var remainingDataArr:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        print (scannedBarcodeArr)
        // Do any additional setup after loading the view.
//        scannedBarcodeArr = []
//        scannedBarcodeArr.addObject("1001")
//        scannedBarcodeArr.addObject("1006")
//        scannedBarcodeArr.addObject("5006")
        
        getDataFromDatabse()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BarcodeDetailViewController.displayResponse), name: "com.time-em.signInOutAllResponse", object: nil)

    }
    
    func getDataFromDatabse()  {
        let database = databaseFile()
        dataArray = []
        noDataObjects = []
        
        for i in scannedBarcodeArr {
            var dataDict:NSDictionary = [:]
            dataDict = database.getTeamDetail(i as! String)
            if dataDict.valueForKey("LoginCode") != nil {
               dataArray.addObject(dataDict)
            }else{
              noDataObjects.addObject(i as! String)
            }
            
        }
        
//        if remainingDataArr.count > 0 {
//            combineRemainingData()
//        }
        
        if noDataObjects.count > 0 {
               var ids:String!
        for (var j=0; j<noDataObjects.count;j+=1) {
            if j==0 {
                ids = "\(noDataObjects[j])"
            }else{
                ids = "\(ids),\(noDataObjects[j])"
            }
        }
        
        let api = ApiRequest()
        api.getuserListByLoginCode(ids)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BarcodeDetailViewController.responseForLoginCodes), name: "com.time-em.getuserListByLoginCode", object: nil)
        }
        
        
        tableView.reloadData()
    }
    
    func combineRemainingData () {
        if remainingDataArr.count > 0 {
            for i in remainingDataArr {
                
                dataArray.addObject(i)
            }
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnSignInAll(sender: AnyObject) {
        var userids:String!
        
        for (var j=0; j<dataArray.count;j+=1) {
            let dict:NSDictionary  = dataArray[j] as! NSDictionary
                if j==0 {
                    userids = "\(dict.valueForKey("Id")!)"
                }else{
                    userids = "\(userids),\(dict.valueForKey("Id")!)"
                }
            
        }
        let api = ApiRequest()
        api.teamSignInAll(userids, view: self.view)
        
    }
    
    @IBAction func btnSignOutAll(sender: AnyObject) {
        var userids:String!
        
        for (var j=0; j<dataArray.count;j+=1) {
            let dict:NSDictionary  = dataArray[j] as! NSDictionary
            if j==0 {
                userids = "\(dict.valueForKey("Id")!)"
            }else{
                userids = "\(userids),\(dict.valueForKey("Id")!)"
            }
            
        }
        let api = ApiRequest()
        api.teamSignOutAll(userids, view: self.view)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
        
        
        let dict:NSDictionary  = dataArray[indexPath.row] as! NSDictionary
        
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
        
         cell.selectionStyle = .None
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    func responseForLoginCodes(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: "Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            if NSUserDefaults.standardUserDefaults().valueForKey("getuserListByLoginCode") != nil {
                let data =    NSUserDefaults.standardUserDefaults().valueForKey("getuserListByLoginCode") as? NSData
                remainingDataArr = []
                remainingDataArr = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSArray
                combineRemainingData()
            NSUserDefaults.standardUserDefaults().removeObjectForKey("getuserListByLoginCode")
            }

        }else{
            alert = UIAlertController(title: "Time'em", message: "Failed", preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        if status.lowercaseString.rangeOfString("success") != nil {
            alert = UIAlertController(title: "Time'em", message: "Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            self.dismissViewControllerAnimated(true, completion: {});
            self.navigationController?.popViewControllerAnimated(true)

        }else{
            alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        getDataFromDatabse()
    }

}
