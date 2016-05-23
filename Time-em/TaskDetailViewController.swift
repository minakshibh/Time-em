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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(taskData)

    lblTaskDate.text = "\(taskData.valueForKey("CreatedDate") as? String)"
    txtTaskDescription.text = taskData.valueForKey("TaskName") as? String
    txtComments.text = taskData.valueForKey("Comments") as? String
    lblHourWorked.text = taskData.valueForKey("TimeSpent")  as? String
    
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, 0)
        scrollView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

}
