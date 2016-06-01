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
    @IBOutlet var lblTaskDate: UILabel!
    @IBOutlet var txtComments: UITextView!
    @IBOutlet var lblHourWorked: UILabel!
    @IBOutlet var txtTaskDescription: UITextView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(taskData)

    lblTaskDate.text = "\(taskData.valueForKey("CreatedDate") as? String)"
    txtTaskDescription.text = taskData.valueForKey("TaskName") as? String
    txtComments.text = taskData.valueForKey("Comments") as? String
    lblHourWorked.text = taskData.valueForKey("TimeSpent")!  as? String
    
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, 2000)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 450, y: 2000)
        
//        scrollView.contentOffset.x = 0
        if taskData.valueForKey("AttachmentImageFile") != nil {
            
            if taskData.valueForKey("AttachmentImageFile") as? String != "" {
             
                
                let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentImageFile")!)")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue(), {
                       self.imageView.image = UIImage(data: data!)
                    });
                }
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_5 {
        scrollView.contentSize = CGSizeMake(320, 650)
        }
    }
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

}
