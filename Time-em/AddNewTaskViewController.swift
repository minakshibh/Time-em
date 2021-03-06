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
import JLToast
import Toast_Swift

class AddNewTaskViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet var taskDropDown: UIButton!
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
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
     @IBOutlet var lblDate: UILabel!
    @IBOutlet var videoFileName:UILabel!
     @IBOutlet var btncancel: UIButton!
    
    @IBOutlet var video_play: UIImageView!
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
     var isoffline: String! = "false"
    var uniqueno: String! = ""
    var videoStatus:Bool = false
    var currentUserID:String! = nil
    var currentUserActivityId:String! = nil
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

         btncancel.hidden = true
        
        videoFileName.layer.borderWidth = 0.5
        videoFileName.layer.borderColor = UIColor.blackColor().CGColor
         videoFileName.hidden = true

        
        uploadBtn.layer.cornerRadius = 5
        uploadedImage.layer.cornerRadius = 5
        addBtn.layer.cornerRadius = 5
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = UIColor(red: 207, green: 237, blue: 244, alpha: 1).CGColor
        
        if createdDate != nil {
            lblDate.text = createdDate
        }else{
             lblDate.text = ""
        }
        
        if isEditting == "true" {
            
     addBtn.setTitle("Update", forState: UIControlState.Normal)
            lblDate.hidden = true
            self.titleLbl.text = "Edit Task"
            self.selectTaskTxt.text = "\(editTaskDict.valueForKey("TaskName")!)"
            self.commentsTxt.text = "\(editTaskDict.valueForKey("Comments")!)"
            if self.commentsTxt.text != "" {
                self.commentPlaceholder.hidden = true
            }
            self.uniqueno = "\(editTaskDict.valueForKey("uniqueno")!)"
            numberOfHoursTxt.text = "\(roundToPlaces(Double("\(editTaskDict.valueForKey("TimeSpent")!)")!, places: 2))"

//            self.numberOfHoursTxt.text = "\(editTaskDict.valueForKey("TimeSpent")!)"
            self.taskId = "\(editTaskDict.valueForKey("TaskId")!)"
            self.createdDate = "\(editTaskDict.valueForKey("CreatedDate")!)"
            let dateStr = "\(self.createdDate)".componentsSeparatedByString(" ")[0]
            let day = dateStr.componentsSeparatedByString("/")[0]
            let month = dateStr.componentsSeparatedByString("/")[1]
            let year = dateStr.componentsSeparatedByString("/")[2]
            self.createdDate = "\(month)-\(day)-\(year)"
            self.editId = "\(editTaskDict.valueForKey("Id")!)"
            self.isoffline = "\(editTaskDict.valueForKey("isoffline")!)"
            //--------
            if editTaskDict.valueForKey("AttachmentImageFile") != nil {
                
                if editTaskDict.valueForKey("AttachmentImageFile") as? String != "" {
                    
                    if "\(self.editTaskDict.valueForKey("isoffline")!)" == "true" {
                        let database = databaseFile()
                        let dataArr:NSMutableArray!
                        dataArr = database.getImageForUrl("\(self.editTaskDict.valueForKey("AttachmentImageFile")!)",imageORvideo:"AttachmentImageFile")
                        
                        if dataArr.count > 0 {
                            if "\(dataArr[0])".characters.count != 0 {
                                let data1:NSData = dataArr[0] as! NSData
                                let count = data1.length / sizeof(UInt8)
                                if count > 0 {
                                    delay(0.001){
                                        let data:NSData = dataArr[0] as! NSData
                                        let userImageData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                                        self.uploadImageView.hidden = false
                                        self.uploadedImage.image = UIImage(data: userImageData)
                                    }
                                    return
                                }
                            }
                        }
                        
                    }
                    
                    uploadedImage.sd_setImageWithURL(NSURL(string: "\(self.editTaskDict.valueForKey("AttachmentImageFile")!)"), placeholderImage: UIImage(named: "cross-popup"), options: .RefreshCached)
                    self.uploadImageView.hidden = false
                    
                    

                }else{
                    uploadedImage.hidden = true
                }
                
            }else{
                uploadedImage.hidden = true
            }
            
            
            
            
            
            
            
            if editTaskDict.valueForKey("AttachmentVideoFile") != nil {
                
                if editTaskDict.valueForKey("AttachmentVideoFile") as? String != "" {
                    
                    // check and get image from databse
                    let database = databaseFile()
                    let dataArr:NSMutableArray!
                    dataArr = database.getImageForUrl("\(editTaskDict.valueForKey("AttachmentVideoFile")!)",imageORvideo:"AttachmentVideoFile")
                    if dataArr.count > 0 {
                        if "\(dataArr[0])" != "" {
                            let url = NSURL(string: "\(self.editTaskDict.valueForKey("AttachmentVideoFile")!)")
                            
                            
                            let data:NSData = dataArr[0] as! NSData
                            let userVideoData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                            videoData = userVideoData
                            generateThumbnail(url!)
                            self.uploadImageView.hidden = false
                            uploadedImage.hidden = false
                            return
                        }
                    }
                    
                    
                    
                    // downloadVideo  and save to databse
                    
                    let url = NSURL(string: "\(self.editTaskDict.valueForKey("AttachmentVideoFile")!)")
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        
                        let data = NSData(contentsOfURL: url!)
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            //----
                            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                            let database = databaseFile()
                            database.addImageToTask("\(self.editTaskDict.valueForKey("AttachmentVideoFile")!)", AttachmentImageData: encodedData,imageORvideo:"AttachmentVideoFile")
                            self.videoData = data!
                            self.generateThumbnail(url!)

                        });
                    }
                    
                }
            }
            //------
//            let imageUrl = "\(editTaskDict.valueForKey("AttachmentImageFile")!)"
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                if let url = NSURL(string: imageUrl) {
//                    if let data = NSData(contentsOfURL: url) {
//                        self.uploadedImage.image = UIImage(data: data)
//                        self.uploadImageView.hidden = false
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                });
//            }
            
            
            
        }
        
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
                   // [self.selectTaskTxt sizeToFit];
                   // self.selectTaskTxt.sizeToFit()

                    
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
        
        
        
        scrollView.scrollEnabled = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        numberToolbar.barStyle = .BlackTranslucent
        numberToolbar.items = [UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(myProfileViewController.cancelNumberPad)), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(myProfileViewController.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        numberOfHoursTxt.inputAccessoryView = numberToolbar
    }
    @IBAction func btnPlayVideo(sender: AnyObject) {
        playVideo(videoData)
    }
    func playVideo(data:NSData) {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
        videoStatus = data.writeToFile(temppath, atomically: true)
        
        if videoStatus {
            let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: temppath)))
            let playerItem = AVPlayerItem(asset:videoAsset)
            
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            presentViewController(playerViewController, animated:true){
                playerViewController.player!.play()
            }
            
        }
    }
    override func viewDidDisappear(animated: Bool) {
        
        if videoStatus {
            let filemanager = NSFileManager.defaultManager()
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .   UserDomainMask, true)[0] as String
            let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
            do{
                try filemanager.removeItemAtPath(temppath)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
        }
    }
    func generateThumbnail (url:NSURL) {
        do {
            let asset = AVURLAsset(URL: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(CGImage: cgImage)
            self.uploadImageView.hidden = false
            uploadedImage.hidden = false
            video_play.hidden = false
            self.uploadedImage.image = uiImage
            
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        
        
        
        let sizeThatFitsTextView: CGSize = self.commentsTxt.sizeThatFits(CGSizeMake(self.commentsTxt.frame.size.width, CGFloat(MAXFLOAT)))
         if isEditting == "true" {
            self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height
        }
    }
    override func viewDidAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_6 ||  Reachability.DeviceType.IS_IPHONE_6P{
            
            //  selectTaskTxt.frame
            selectTaskTxt.frame = (frame: CGRectMake(self.selectTaskTxt.frame.origin.x, self.selectTaskTxt.frame.origin.y,self.selectTaskTxt.frame.size.width + 45 ,self.selectTaskTxt.frame.size.height))
            
        }
    }
    func cancelNumberPad() {
        numberOfHoursTxt.resignFirstResponder()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
        numberOfHoursTxt.text = ""
    }
    
    func doneWithNumberPad() {
        numberOfHoursTxt.resignFirstResponder()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
        
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
        taskDropDown.layer.borderColor = UIColor.clearColor().CGColor
        } else {
            dropDown.hide()
        }
    }
  
    @IBAction func uploadImage(sender: AnyObject) {
        //~~ Set delegate of UIImagePickerController
        imagePicker.delegate = self
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
        videoData = NSData()
        uploadedImage.image = nil
    }
    
  
    
   @IBAction func btnplayVideo(sender: AnyObject) {
    var count:Int = 0
    count = videoData.length / sizeof(UInt8)
    
    if(count > 0)
    {
        playVideo(videoData)
    }
    
//    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//    let documentsDirectory:AnyObject = paths[0]
//    let dataPath = documentsDirectory.stringByAppendingPathComponent("Test.mp4")
//    
//    let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
//    let playerItem = AVPlayerItem(asset:videoAsset)
//    
//    let player = AVPlayer(playerItem: playerItem)
//    let playerViewController = AVPlayerViewController()
//    playerViewController.player = player
//    
//    presentViewController(playerViewController, animated:true){
//        playerViewController.player!.play()
//    }
    }
    
    @IBAction func addUpdateTask(sender: AnyObject) {
        
//        if numberOfHoursTxt.text?.characters.count == 0 && string == "."
//        {
//            return false
//        }
        
        if (numberOfHoursTxt.text!) == "." {
            self.view.makeToast("Please enter valid hours", duration: 2.0, position: .Center)
            numberOfHoursTxt.becomeFirstResponder()
            return
        }

        
        
        if Int(numberOfHoursTxt.text!) == 0 {
            self.view.makeToast("number of hours should be greater than 0", duration: 2.0, position: .Center)
            numberOfHoursTxt.becomeFirstResponder()
            return
        }
        
        if self.taskId == "" && commentsTxt.text.characters.count == 0 && commentsTxt.text.characters.count == 0 {
            
            taskDropDown.layer.cornerRadius = 5
            taskDropDown.layer.borderWidth = 1
            taskDropDown.layer.borderColor = UIColor.redColor().CGColor
            
            commentsTxt.layer.borderColor = UIColor.redColor().CGColor
            commentsTxt.layer.borderWidth = 1
            commentsTxt.layer.cornerRadius = 5
            
            numberOfHoursTxt.layer.borderColor = UIColor.redColor().CGColor
            numberOfHoursTxt.layer.borderWidth = 1
            numberOfHoursTxt.layer.cornerRadius = 5

        }
        
        
        commentsTxt.resignFirstResponder()
        numberOfHoursTxt.resignFirstResponder()
        
        numberOfHoursTxt.resignFirstResponder()
        main {
            self.lblbackground.frame.origin.y += 150
        }
        if self.taskId == "" {
            let alert = UIAlertController(title: "Time'em", message: "Select Task type before continue.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            taskDropDown.layer.cornerRadius = 5
            taskDropDown.layer.borderWidth = 1
            taskDropDown.layer.borderColor = UIColor.redColor().CGColor
            
        }
        let taskIds:NSString = self.taskId
        if commentsTxt.text.characters.count == 0 {
//            let alert = UIAlertController(title: "Time'em", message: "Enter some comments  before continue.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            commentsTxt.becomeFirstResponder()
            
            commentsTxt.layer.borderColor = UIColor.redColor().CGColor
            commentsTxt.layer.borderWidth = 1
            commentsTxt.layer.cornerRadius = 5

            
        }
        
         let comments = self.commentsTxt.text! as String
        
        if numberOfHoursTxt.text?.characters.count == 0 {
//            let alert = UIAlertController(title: "Time'em", message: "Enter hours for tasks before continue", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            numberOfHoursTxt.becomeFirstResponder()
            
            numberOfHoursTxt.layer.borderColor = UIColor.redColor().CGColor
            numberOfHoursTxt.layer.borderWidth = 1
            numberOfHoursTxt.layer.cornerRadius = 5
            
        }
        let timespend = self.numberOfHoursTxt.text! as String

        var userId:String = ""
        var activityId:String = ""
        if currentUserID != nil {
            userId = currentUserID
            activityId = currentUserActivityId
        }else{
            activityId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_ActivityId") as! String
            if let field = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")
            {
                userId = field as! String
            }else{
                userId = ""
            }
        }
        
        
        
        let  taskName = self.selectTaskTxt.text! as String
       
        let createdDates = self.createdDate! as String
        print(createdDates)
        let assignedTasks =  ApiRequest()
        var imageData = NSData()
        if uploadedImage.image != nil {
            imageData = UIImagePNGRepresentation(uploadedImage.image!)!
        }
        var videoRecordedData = NSData()
//        if isVideoRecorded {
        let count = videoData.length / sizeof(UInt8)
        if count > 0 {
            videoRecordedData = videoData
            isVideoRecorded = true
        }
        numberOfHoursTxt.resignFirstResponder()
        commentsTxt.resignFirstResponder()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
        
       let currentUSerSIGNIN =  "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)"
        
//        if currentUSerSIGNIN == "0"{
//            let alert = UIAlertController(title: "Time'em", message: "Please SignIn before adding task.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//        }
        
        if numberOfHoursTxt.text?.characters.count > 0 &&  commentsTxt.text.characters.count > 0 &&
        !self.taskId.isEmpty
        {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddNewTaskViewController.displayResponse), name: notificationKey, object: nil)
        assignedTasks.AddUpdateNewTask(imageData,videoData: videoRecordedData, ActivityId:activityId, TaskId: taskIds as String, UserId:userId, TaskName:taskName, TimeSpent:timespend , Comments:comments , CreatedDate:createdDates , ID: editId as String, view: self.view, isVideoRecorded:isVideoRecorded,isoffline:self.isoffline,uniqueno: self.uniqueno)
        
        }
//        assignedTasks.newAddTaskwebservice(activityId, TaskId: taskIds as String, UserId: userId, TaskName: taskName, TimeSpent: timespend, Comments: comments, CreatedDate: createdDates, ID: editId, view: self.view)
        
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    func update()  {
        self.resetTheView()
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {});
        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "isEditingOrAdding")
    }
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:notificationKey, object:nil)
        if status.lowercaseString == "success sync" {
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(AddNewTaskViewController.update), userInfo: nil, repeats: true)
            return
        } else if status.lowercaseString == "failure in adding task."{
            let alert = UIAlertController(title: "Failed to add task.", message: "Either you are not singin or trying to add future date task.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
        if status.lowercaseString == "success"{
         self.resetTheView()
            self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: {});
        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "isEditingOrAdding")
        }else{
            let alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
        
        
        
        
        
        let sizeThatFitsTextView: CGSize = self.commentsTxt.sizeThatFits(CGSizeMake(self.commentsTxt.frame.size.width, CGFloat(MAXFLOAT)))
        print(sizeThatFitsTextView.height)
        if sizeThatFitsTextView.height > 62 {
            
        }else{
        self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height
        }
        
        if commentsTxt.text.characters.count == 0 && text == "" {
            commentPlaceholder.hidden = false
        }
        
            if (text == "\n") {
                numberOfHoursTxt.becomeFirstResponder()
            }
       
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        commentsTxt.layer.borderColor = UIColor.clearColor().CGColor
      

        commentPlaceholder.hidden = true
        scrollView.scrollEnabled = true
         scrollView.contentSize = CGSizeMake(320, 700)
        numberOfHoursTxt.layer.borderColor = UIColor.clearColor().CGColor

//            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        if scrollView.contentOffset.y != 200.0 {
            scrollView.setContentOffset(CGPointMake(0, 200), animated: true)
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(320, 700)
        numberOfHoursTxt.layer.borderColor = UIColor.clearColor().CGColor

         //commentsTxt.layer.borderColor = UIColor.clearColor().CGColor
        
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

        
        
//        limit for not data entered more than 24
        if textField == numberOfHoursTxt {
//            if Int(string) > 2 && numberOfHoursTxt.text?.characters.count == 0{
//                JLToast.makeText("maximum hours allowed is 24hrs", duration: JLToastDelay.ShortDelay)
//                return false
//            }
            
            //let str1 = ""
          

          
     
      
            if string == "."{
             let str = "\(numberOfHoursTxt.text!)"
                 if str.rangeOfString(".") != nil{
                    return false
                }
               
            }
            
            
            
         
            if numberOfHoursTxt.text?.characters.count == 0 {
                if Int(string) == 0 {
                    self.view.makeToast("No. of hours should be greater than 0.", duration: 2.0, position: .Center)
                    return false
                }
            }
            
            if numberOfHoursTxt.text?.characters.count == 1 {
                let str = "\(numberOfHoursTxt.text!)\(string)"
                if Int(str) > 12 {
                    self.view.makeToast("maximum hours allowed is 12hrs", duration: 2.0, position: .Center)
                  JLToast.makeText("maximum hours allowed is 12hrs", duration: JLToastDelay.ShortDelay)
                    return false
                    
                }
            }
            
            if numberOfHoursTxt.text?.characters.count >= 2 && string != ""{
                 let textstr = "\(numberOfHoursTxt.text!)"
                if Int(textstr) == 12 && string == "."{
                    return false
                }
                
                
                let str = "\(numberOfHoursTxt.text!)\(string)"
                if str.rangeOfString(".") != nil{
                    let val = str.componentsSeparatedByString(".")[1]
                    if val.characters.count > 2{
                        return false
                    }
                }
                if Int(str) <= 12 {
                    return true
                }
                self.view.makeToast("maximum hours allowed is 12hrs", duration: 2.0, position: .Center)
                return false
            }
        }
        
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
            video_play.hidden = true
           uploadImageView.hidden = false
            uploadedImage.hidden = false
            uploadedImage.contentMode = .ScaleToFill
            uploadedImage.image = pickedImage
            videoData = NSData()
        }
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            
            // Save the video to the app directory so we can play it later
            videoData = NSData(contentsOfURL: pickedVideo)!
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("Test.mp4")
            videoData.writeToFile(dataPath, atomically: false)
           // btnplayVideo.hidden = false
            
           // self.uploadImageView.hidden = false
           // self.uploadedImage.backgroundColor = UIColor.grayColor()
           // uploadedImage.hidden = false
            //video_play.hidden = false
              videoFileName.hidden = false
            btncancel.hidden = false
            btncancel!.addTarget(self, action: "sampleButtonClicked", forControlEvents: .TouchUpInside)
           
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clearText(sender: AnyObject) {
       videoFileName.text=""
    }
    
    func sampleButtonClicked(){
        
        videoFileName.text=""
        videoFileName.hidden = true
        btncancel.hidden = true
  
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
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    
    
}


