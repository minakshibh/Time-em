//
//  sendNotificationViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 27/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class sendNotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let api = ApiRequest()
        api.GetNotificationType()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sendNotificationViewController.GetNotificationTypeResponse), name: "com.time-em.NotificationTypeloginResponse", object: nil)

        
        tableView = UITableView(frame: CGRectMake(btnSelectRecipients.frame.origin.x, btnSelectRecipients.frame.origin.y+btnSelectRecipients.frame.size.height-3, btnSelectRecipients.frame.size.width, 220), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        //        self.tableViewContact.layer.cornerRadius = 8.0
        self.view.addSubview(tableView)
        tableView.allowsMultipleSelection = true
        tableView.hidden = true
        
        uploadedImage.hidden = true
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

    //~~ TextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        lblPlaceholderComments.hidden = true
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
//        let fileURL = NSBundle.mainBundle().URLForResource("example", withExtension: "png")
//        let fileUploader = FileUploader()
//        fileUploader.addFileURL(fileURL!, withName: "myFile")
//        let data = UIImage(named: "sample")
//        fileUploader.addFileData( UIImageJPEGRepresentation((NSData)data,0.8), withName: "mySecondFile", withMimeType: "image/jpeg" )
//        fileUploader.setValue( "sample", forParameter: "folderName" )
//        var request = NSMutableURLRequest( URL: NSURL(string: "http://myserver.com/uploadFile" )! )
//        request.HTTPMethod = "POST"
//        fileUploader.uploadFile(request: request)
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
