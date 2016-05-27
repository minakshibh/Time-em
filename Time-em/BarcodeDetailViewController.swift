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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print (scannedBarcodeArr)
        // Do any additional setup after loading the view.
        scannedBarcodeArr = []
        scannedBarcodeArr.addObject("1001")
        scannedBarcodeArr.addObject("1006")
        scannedBarcodeArr.addObject("5006")
        
        getDataFromDatabse()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BarcodeDetailViewController.displayResponse), name: "com.time-em.signInOutAllResponse", object: nil)

    }
    
    func getDataFromDatabse()  {
        let database = databaseFile()
        dataArray = []
        noDataObjects = []
        
        for i in scannedBarcodeArr {
            var dataDict:NSMutableDictionary = [:]
            dataDict = database.getTeamDetail(i as! String)
            dataArray.addObject(dataDict)
        }
        
        
       
        for (var j=0; j<dataArray.count;j+=1) {
            let dict:NSMutableDictionary  = dataArray[j] as! NSMutableDictionary
            if  dict.valueForKey("nodata") != nil {
                
                noDataObjects.addObject(scannedBarcodeArr[j])
                dataArray.removeObjectAtIndex(j)
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

    @IBAction func btnSignInAll(sender: AnyObject) {
        var userids:String!
        
        for (var j=0; j<dataArray.count;j+=1) {
            let dict:NSMutableDictionary  = dataArray[j] as! NSMutableDictionary
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
            let dict:NSMutableDictionary  = dataArray[j] as! NSMutableDictionary
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
        
        
        let dict:NSMutableDictionary  = dataArray[indexPath.row] as! NSMutableDictionary
        
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
       
    }

    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            
        }else{
            alert = UIAlertController(title: "Time'em", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        getDataFromDatabse()
    }

}
