//
//  NotificationDetailViewController.swift
//  Time-em
//
//  Created by Br@R on 06/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation
class NotificationDetailViewController: UIViewController {
    
    var notificationData:NSMutableDictionary! = [:]
    @IBOutlet var dateTimeLbl: UILabel!
    @IBOutlet var notification_subject_lbl: UITextView!
    @IBOutlet var notification_messageLbl: UITextView!
    @IBOutlet var sender_name_Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .displayData()

    }
    
    func displayData() {
        
        if notificationData.valueForKey("Subject") is NSNull
        {
            notification_subject_lbl.text = ""
        }
        else{
            notification_subject_lbl.text = "\(notificationData.valueForKey("Subject")!)"
        }
        
        if notificationData.valueForKey("SenderFullName") is NSNull
        {
            sender_name_Lbl.text = ""
        }
        else{
            sender_name_Lbl.text = "\(notificationData.valueForKey("SenderFullName")!)"
        }

        
        if notificationData.valueForKey("Message") is NSNull
        {
            notification_messageLbl.text = ""
        }
        else{
            notification_messageLbl.text = "\(notificationData.valueForKey("Message")!)"
        }
        
        var dateStr: String = ""
        
        if notificationData.valueForKey("createdDate") is NSNull
        {
            dateTimeLbl.text = ""
        }
        else{
            dateStr = "\(notificationData.valueForKey("createdDate")!)"
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let date: NSDate = dateFormatter.dateFromString(dateStr)!
            let currentDate: NSDate = NSDate()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.stringFromDate(date)
            let date2String = dateFormatter.stringFromDate(currentDate)
            if date1String == date2String {
                dateFormatter.dateFormat = "HH:mm"
                dateStr = dateFormatter.stringFromDate(date)
                dateTimeLbl.text = "Today,\(dateStr)"
            }
            else{
                dateStr = self.dateConversion(date) as String
                dateTimeLbl.text = dateStr as String
            }
        }
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func dateConversion(date : NSDate) -> NSString {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    
}