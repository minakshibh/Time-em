//
//  AddNewTaskViewController.swift
//  Time-em
//
//  Created by Krishna_Mac_4 on 19/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation
import MobileCoreServices
import AVKit
import AVFoundation

class AddNewTaskViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet var taskDropDown: UIButton!
    @IBOutlet var selectTaskTxt: UITextField!
    @IBOutlet var commentsTxt: UITextView!
    @IBOutlet var commentPlaceholder: UILabel!
    @IBOutlet var numberOfHoursTxt: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var uploadImageView: UIView!
    @IBOutlet var uploadedImage: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var btnplayVideo: UIButton!
    @IBOutlet var lblbackground: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLbl: UILabel!
    let dropDown = DropDown()
    let imagePicker = UIImagePickerController()
    var imageData = NSData()
    var videoData = NSData()
    var isNewTask = Bool()
    var isVideoRecorded = Bool()
    var taskId = String()
    var assignedTasksArray = NSMutableArray()
    var createdDate:String!
    var editTaskDict:NSDictionary!    
    let notificationKey = "com.time-em.addTaskResponse"
    var isEditting: String!
    var editId: String! = "0"
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        
        uploadBtn.layer.cornerRadius = 5
        uploadedImage.layer.cornerRadius = 5
        addBtn.layer.cornerRadius = 5
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = UIColor(red: 207, green: 237, blue: 244, alpha: 1).CGColor
        
        
        if isEditting == "true" {
            self.titleLbl.text = "Edit Task"
            self.selectTaskTxt.text = "\(editTaskDict.valueForKey("TaskName")!)"
            self.commentsTxt.text = "\(editTaskDict.valueForKey("Comments")!)"
            if self.commentsTxt.text != "" {
                self.commentPlaceholder.hidden = true
            }
            self.numberOfHoursTxt.text = "\(editTaskDict.valueForKey("TimeSpent")!)"
            self.taskId = "\(editTaskDict.valueForKey("TaskId")!)"
            self.createdDate = "\(editTaskDict.valueForKey("CreatedDate")!)"
            let dateStr = "\(self.createdDate)".componentsSeparatedByString(" ")[0]
            let day = dateStr.componentsSeparatedByString("/")[0]
            let month = dateStr.componentsSeparatedByString("/")[1]
            let year = dateStr.componentsSeparatedByString("/")[2]
            self.createdDate = "\(month)-\(day)-\(year)"
            
            let imageUrl = "\(editTaskDict.valueForKey("AttachmentImageFile")!)"
            dispatch_async(dispatch_get_main_queue()) {
        
            if let url = NSURL(string: imageUrl) {
                if let data = NSData(contentsOfURL: url) {
                    self.uploadedImage.image = UIImage(data: data)
                    self.uploadImageView.hidden = false
                }        
            }
            }
            
            self.editId = "\(editTaskDict.valueForKey("Id")!)"
            
        }
        let assignedTasks = ApiRequest()
        
        let currentUserId = NSUserDefaults.standardUserDefaults() .objectForKey("currentUser_id")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddNewTaskViewController.getAssignedTaskIListResponse), name: "com.time-em.getAssignedTaskIList", object: nil)
        assignedTasks.GetAssignedTaskIList(currentUserId as! String, view: self.view)
        let databaseFetch = databaseFile()
        assignedTasksArray = databaseFetch.getAssignedTasks()
        
        var dropdownArray = NSMutableArray()
        dropdownArray = ["Add New Task"]

        for i in 0 ..< assignedTasksArray.count {
            let taskNameArray:NSMutableDictionary = assignedTasksArray .objectAtIndex(i) as! NSMutableDictionary
            
            dropdownArray.addObject(taskNameArray.valueForKey("taskName")! as! String)

        }
        dropDown.dataSource = dropdownArray.mutableCopy() as! [String]

  
        //~~ Add Value to textfield from dropdown
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            if index == 0 {
                self.taskId = "0"
                self.isNewTask = true
                //~~ Show Alertview with Textfield at 0th Index
                var tField: UITextField!
                
                func configurationTextField(textField: UITextField!)
                {
                    print("generating the TextField")
                    textField.placeholder = "Enter an item"
                    tField = textField
                }
                
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    print("Cancelled !!")
                }
                
                let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    print("Done !!")
                    print("Item : \(tField.text)")
                    self.selectTaskTxt.text = tField.text
                }))
                self.presentViewController(alert, animated: true, completion: {
                    print("completion block")
                })
            }else{
                let taskNameArray:NSMutableDictionary = self.assignedTasksArray .objectAtIndex(index-1) as! NSMutableDictionary
                self.taskId = taskNameArray.valueForKey("taskId") as! String
                self.isNewTask = false
                self.selectTaskTxt.text = item
            }
        }
        
        dropDown.anchorView = selectTaskTxt
        dropDown.bottomOffset = CGPoint(x: 0, y:selectTaskTxt.bounds.height)
        
        //~~ Set delegate of UIImagePickerController
        imagePicker.delegate = self
        
        scrollView.scrollEnabled = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func getDataFUnction(){
        var dropdownArray = NSMutableArray()
        dropdownArray = ["Add New Task"]
        
        for i in 0 ..< assignedTasksArray.count {
            let taskNameArray:NSMutableDictionary = assignedTasksArray .objectAtIndex(i) as! NSMutableDictionary
            
            dropdownArray.addObject(taskNameArray.valueForKey("taskName")! as! String)
            
        }
        dropDown.dataSource = dropdownArray.mutableCopy() as! [String]
        
        
        //~~ Add Value to textfield from dropdown
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            if index == 0 {
                self.taskId = "0"
                self.isNewTask = true
                //~~ Show Alertview with Textfield at 0th Index
                var tField: UITextField!
                
                func configurationTextField(textField: UITextField!)
                {
                    print("generating the TextField")
                    textField.placeholder = "Enter an item"
                    tField = textField
                }
                
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    print("Cancelled !!")
                }
                
                let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    print("Done !!")
                    print("Item : \(tField.text)")
                    self.selectTaskTxt.text = tField.text
                }))
                self.presentViewController(alert, animated: true, completion: {
                    print("completion block")
                })
            }else{
                let taskNameArray:NSMutableDictionary = self.assignedTasksArray .objectAtIndex(index-1) as! NSMutableDictionary
                self.taskId = taskNameArray.valueForKey("taskId") as! String
                self.isNewTask = false
                self.selectTaskTxt.text = item
            }
        }
        
        dropDown.anchorView = selectTaskTxt
        dropDown.bottomOffset = CGPoint(x: 0, y:selectTaskTxt.bounds.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //~ ~ask Dropdown Action
    @IBAction func selectTaskFromDropDown(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
  
    @IBAction func uploadImage(sender: AnyObject) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let galleryAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let recordAction = UIAlertAction(title: "Record Video", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.setUpRecorder()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(recordAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    
    }
    
    @IBAction func removeUploadedImage(sender: AnyObject) {
        uploadImageView.hidden = true
    }
    
   @IBAction func btnplayVideo(sender: AnyObject) {
    
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsDirectory:AnyObject = paths[0]
    let dataPath = documentsDirectory.stringByAppendingPathComponent("Test.mp4")
    
    let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
    let playerItem = AVPlayerItem(asset:videoAsset)
    
    let player = AVPlayer(playerItem: playerItem)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    
    presentViewController(playerViewController, animated:true){
        playerViewController.player!.play()
    }
    }
    
    @IBAction func addUpdateTask(sender: AnyObject) {
        numberOfHoursTxt.resignFirstResponder()
        main {
            self.lblbackground.frame.origin.y += 150
        }
        let taskIds:NSString = self.taskId
        var userId:String = ""
        let activityId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_ActivityId") as! String
        if let field = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")
        {
            userId = field as! String
        }else{
            userId = ""
        }
        let  taskName = self.selectTaskTxt.text! as String
        let timespend = self.numberOfHoursTxt.text! as String
        let comments = self.commentsTxt.text! as String
        let createdDates = self.createdDate! as String
        print(createdDates)
        let assignedTasks =  ApiRequest()
        var imageData = NSData()
        if uploadedImage.image != nil {
            imageData = UIImagePNGRepresentation(uploadedImage.image!)!
        }
        var videoRecordedData = NSData()
        if isVideoRecorded {
            videoRecordedData = videoData
        }
        assignedTasks.AddUpdateNewTask(imageData,videoData: videoRecordedData, ActivityId:activityId, TaskId: taskIds as String, UserId:userId, TaskName:taskName, TimeSpent:timespend , Comments:comments , CreatedDate:createdDates , ID: editId as String, view: self.view, isVideoRecorded:isVideoRecorded)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddNewTaskViewController.displayResponse), name: notificationKey, object: nil)
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        if status.lowercaseString == "success"{
         self.resetTheView()
        }
    }
    func getAssignedTaskIListResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        if status.lowercaseString == "success"{
            self.resetTheView()
        }
        getDataFUnction()
    }
    //~~ TextView Delegates
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
            if (text == "\n") {
                numberOfHoursTxt.becomeFirstResponder()
            }
       
        return true
    }
    func textViewDidBeginEditing(textView: UITextView) {
        commentPlaceholder.hidden = true
        scrollView.scrollEnabled = true
         scrollView.contentSize = CGSizeMake(320, 700)
        
//            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        if scrollView.contentOffset.y != 200.0 {
            scrollView.setContentOffset(CGPointMake(0, 200), animated: true)
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(320, 700)
        
//            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        if scrollView.contentOffset.y != 200.0 {
          scrollView.setContentOffset(CGPointMake(0, 200), animated: true)
        }
        
       return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        scrollView.scrollEnabled = false
        print(scrollView.contentOffset)
//        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//        scrollView.contentSize = CGSizeMake(0, 0)
        return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        scrollView.scrollEnabled = false
//        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//        scrollView.contentSize = CGSizeMake(0, 0)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
         if (string == "\n") {
         numberOfHoursTxt.resignFirstResponder()
            print(scrollView.setContentOffset)
            if scrollView.contentOffset.y == 200.0 {
//                scrollView.setContentOffset(CGPointMake(200, 0), animated: true)
                self.automaticallyAdjustsScrollViewInsets = false
            }
            scrollView.contentSize = CGSizeMake(0, 0)
        }
        return true
    }

//    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
//        scrollView.setContentOffset(CGPointMake(0,-200), animated: true)
//        scrollView.contentSize = CGSizeMake(0, 0)
//        textField.resignFirstResponder()
//        return true
//    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImageView.hidden = false
            uploadedImage.contentMode = .ScaleToFill
            uploadedImage.image = pickedImage
        }
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            
            // Save the video to the app directory so we can play it later
            videoData = NSData(contentsOfURL: pickedVideo)!
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("Test.mp4")
            videoData.writeToFile(dataPath, atomically: false)
            btnplayVideo.hidden = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetTheView() {
        uploadImageView.hidden = true
        self.selectTaskTxt.text = ""
        self.commentsTxt.text = ""
        self.numberOfHoursTxt.text = ""
        self.commentPlaceholder.hidden = false
    }
    
    func setUpRecorder(){
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            isVideoRecorded = true
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                self.imagePicker.sourceType = .Camera
                self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.imagePicker.allowsEditing = false
                self.imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("Rear camera doesn't exist")
            }
        } else {
            print("Camera inaccessable")
        }
    }
    

    
   
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            let topView:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 20))
            main {
            self.lblbackground.frame.origin.y -= 150
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
             main {
            self.lblbackground.frame.origin.y += 150
            }
            }
    }
}
