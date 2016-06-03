//
//  TaskDetailViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 20/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController ,UIScrollViewDelegate{

    var taskData:NSMutableDictionary! = [:]
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var TextHeadingHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblTaskDate: UILabel!
    @IBOutlet var txtComments: UITextView!
    @IBOutlet var lblHourWorked: UILabel!
    @IBOutlet var txtTaskDescription: UITextView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        print(taskData)

    txtComments.scrollEnabled = false
        
    txtTaskDescription.text = taskData.valueForKey("TaskName") as? String
    txtComments.text = taskData.valueForKey("Comments") as? String
    lblHourWorked.text = taskData.valueForKey("TimeSpent")!  as? String
    print(taskData.valueForKey("CreatedDate")!)
        
        if taskData.valueForKey("TaskName") != nil {
        
        var dateStr = "\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[0]
        var dateArr = dateStr.componentsSeparatedByString("/") as? NSArray
        dateStr = "\(dateArr![2])-\(dateArr![1])-\(dateArr![0])T\("\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[1])"
        
        
                        let dateFormatter: NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        
                        let date: NSDate = dateFormatter.dateFromString(dateStr)!
                        // create date from string
                        // change to a readable time format and change to local time zone
                        dateFormatter.dateFormat = "EEE MMM d, yyyy"
        
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        let timestamp: String = dateFormatter.stringFromDate(date)
        lblTaskDate.text = "\(timestamp)"
        }else {
             lblTaskDate.text = "\(taskData.valueForKey("CreatedDate")!)"
        }
        
        
        
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, 2000)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 450, y: 2000)
        
//        scrollView.contentOffset.x = 0
        if taskData.valueForKey("AttachmentImageFile") != nil {
            
            
            if taskData.valueForKey("AttachmentImageFile") as? String != "" {
             
            if taskData.valueForKey("AttachmentImageData") != nil  && "\(taskData.valueForKey("AttachmentImageData")!)" != "" {
                let imageFile = taskData.valueForKey("AttachmentImageData") as? NSData
                let userData = NSKeyedUnarchiver.unarchiveObjectWithData(imageFile!) as? NSData
                self.imageView.image = UIImage(data: userData!)
                return
            }
                
                let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentImageFile")!)")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue(), {
                        if self.imageView != nil {
                       self.imageView.image = UIImage(data: data!)
                        }
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        let database = databaseFile()
                        database.addImageToTask("\(self.taskData.valueForKey("AttachmentImageFile")!)", AttachmentImageData: encodedData)
                    });
                }
            }else{
              imageView.hidden = true
            }
            
        }else{
            imageView.hidden = true
        }
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_5 {
        scrollView.contentSize = CGSizeMake(320, 700)
        }
        
        let sizeThatFitsTextView: CGSize = self.txtComments.sizeThatFits(CGSizeMake(txtComments.frame.size.width, CGFloat(MAXFLOAT)))
        TextViewHeightConstraint.constant = sizeThatFitsTextView.height
        
        
        let sizeThatFitsTextView1: CGSize = self.txtTaskDescription.sizeThatFits(CGSizeMake(txtTaskDescription.frame.size.width, CGFloat(MAXFLOAT)))
        TextHeadingHeightConstraint.constant = sizeThatFitsTextView1.height

        

    }
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

}
