//
//  sendNotificationViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 27/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class sendNotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet var taskDropDown: UIButton!
    let dropDown = DropDown()
    @IBOutlet var txtSelectMessage: UITextField!
    @IBOutlet var txtComment: UITextView!
    @IBOutlet var txtSubject: UITextView!
    @IBOutlet var lblPlaceholderComments: UILabel!
    @IBOutlet var lblPlaceholderSelectrecipients: UILabel!
    @IBOutlet var lblPlaceholderSubject: UILabel!
    var notificationTypeDropdownArray:NSArray = []
    @IBOutlet var btnSelectRecipients: UIButton!
    var tableView: UITableView!
    var selectedUser:NSMutableArray = []
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var uploadedImage:UIImageView!
    @IBOutlet var btnUploadImage:UIButton!
    let imagePicker = UIImagePickerController()
     @IBOutlet var scrollView: UIScrollView!
    var NotificationTypeId:String! = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let api = ApiRequest()
        api.GetNotificationType()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sendNotificationViewController.GetNotificationTypeResponse), name: "com.time-em.NotificationTypeloginResponse", object: nil)
        
        
        uploadedImage.hidden = true
        
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height*1.5)
        scrollView.backgroundColor = UIColor.clearColor()
                scrollView.contentOffset.x = 0
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView = UITableView(frame: CGRectMake(btnSelectRecipients.frame.origin.x, btnSelectRecipients.frame.origin.y+btnSelectRecipients.frame.size.height-3, btnSelectRecipients.frame.size.width, 220), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        //        self.tableViewContact.layer.cornerRadius = 8.0
        self.view.addSubview(tableView)
        tableView.allowsMultipleSelection = true
        tableView.hidden = true
    }
    
    func setDropDown(){
        let idArr:NSMutableArray = []
        let nameArr:NSMutableArray = []
        
        for  i in notificationTypeDropdownArray {
            idArr.addObject(i.valueForKey("id")!)
            nameArr.addObject(i.valueForKey("Name")!)
        }

        
        dropDown.dataSource = nameArr.mutableCopy() as! [String]
        
        //~~ Add Value to textfield from dropdown
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            
            print("Clicked at index \(index)")
            print(nameArr[index])
            print(idArr[index])
            self.txtSelectMessage.text = item
            self.NotificationTypeId = "\(idArr[index])"
        }
        
        dropDown.anchorView = txtSelectMessage
        dropDown.bottomOffset = CGPoint(x: 0, y:txtSelectMessage.bounds.height)
        
    }
    
    func getDataFromDatabase () {
        let database = databaseFile()
       notificationTypeDropdownArray = database.getNotificationType()
        setDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectTaskFromDropDown(sender: AnyObject) {
        
            if dropDown.hidden {
                dropDown.show()
            } else {
                dropDown.hide()
            }
        
        
    }

    //~ TextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == txtComment {
            lblPlaceholderComments.hidden = true
        }else if textView == txtSubject {
            lblPlaceholderSubject.hidden = true
        }
        
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func GetNotificationTypeResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        getDataFromDatabase()
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func btnSelectRecipients(sender: AnyObject) {
        if tableView.hidden {
            tableView.hidden = false
        } else {
            tableView.hidden = true
        }
    }
    @IBAction func btnSend(sender: AnyObject) {

        var imageData = NSData()
        if uploadedImage.image != nil {
            imageData = UIImagePNGRepresentation(uploadedImage.image!)!
        }
        
        let LoginId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as? String
        let subject:String!
        let comments:String!
        
        if txtSubject.text.isEmpty {
            let alert = UIAlertController(title: "Time'em", message: "Enter subject before continue.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else{
            subject = txtSubject.text
        }
        
        if txtComment.text.isEmpty {
            let alert = UIAlertController(title: "Time'em", message: "Enter comments before continue.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else{
            comments = txtComment.text
        }
        
        if NotificationTypeId == " " {
            let alert = UIAlertController(title: "Time'em", message: "Select notification type before continue.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let sendNotification = ApiRequest()
        sendNotification.sendNotification(imageData, LoginId: LoginId!, Subject: subject, Message: comments, NotificationTypeId: NotificationTypeId, notifyto: "123", view: self.view)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sendNotificationViewController.sendnotificationResponse), name: "com.time-em.sendnotification", object: nil)
    }
    func sendnotificationResponse(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        var alert :UIAlertController!
            alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 50
    }

      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCellss", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview();
        }
        
        cell.textLabel?.text = "sample"
        cell.selectionStyle = .None
        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
     func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.hidden = true
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    
     @IBAction func btnUploadImage(sender: AnyObject) {
    // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
    
    // 2
        let deleteAction = UIAlertAction(title: "Camera", style: .Default, handler: {
        (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
        
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
        (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
        
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
    
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
        (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
    
    
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
    
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadedImage.hidden = false
            uploadedImage.contentMode = .ScaleToFill
            uploadedImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
