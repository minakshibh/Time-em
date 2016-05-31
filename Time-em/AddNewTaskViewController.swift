//
//  AddNewTaskViewController.swift
//  Time-em
//
//  Created by Krishna_Mac_4 on 19/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation

class AddNewTaskViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    let dropDown = DropDown()
    let imagePicker = UIImagePickerController()
    var imageData = NSData()
    var isNewTask = Bool()
    var taskId = String()
    var assignedTasksArray = NSMutableArray()
    var createdDate:String!
    var editTaskDict:NSDictionary!    
    let notificationKey = "com.time-em.addTaskResponse"
    var isEditting: String!
    var editId: String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadBtn.layer.cornerRadius = 5
        uploadedImage.layer.cornerRadius = 5
        addBtn.layer.cornerRadius = 5
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = UIColor(red: 207, green: 237, blue: 244, alpha: 1).CGColor
        
        if isEditting == "true" {
            self.selectTaskTxt.text = "\(editTaskDict.valueForKey("TaskName")!)"
            self.commentsTxt.text = "\(editTaskDict.valueForKey("Comments")!)"
            if self.commentsTxt.text != "" {
                self.commentPlaceholder.hidden = true
            }
            self.numberOfHoursTxt.text = "\(editTaskDict.valueForKey("SignedInHours")!)"
            self.taskId = "\(editTaskDict.valueForKey("TaskId")!)"
            self.createdDate = "\(editTaskDict.valueForKey("CreatedDate")!)"
            let dateStr = "\(self.createdDate)".componentsSeparatedByString(" ")[0]
            let day = dateStr.componentsSeparatedByString("/")[0]
            let month = dateStr.componentsSeparatedByString("/")[1]
            let year = dateStr.componentsSeparatedByString("/")[2]
            self.createdDate = "\(month)-\(day)-\(year)"
            
            let imageUrl = "\(editTaskDict.valueForKey("AttachmentImageFile")!)"
            if let url = NSURL(string: imageUrl) {
                if let data = NSData(contentsOfURL: url) {
                    uploadedImage.image = UIImage(data: data)
                    uploadImageView.hidden = false
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
    
    @IBAction func removeUploadedImage(sender: AnyObject) {
        uploadImageView.hidden = true
    }
    
   @IBAction func btnplayVideo(sender: AnyObject) {
    }
    
    @IBAction func addUpdateTask(sender: AnyObject) {
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
        let assignedTasks = ApiRequest()
        var imageData = NSData()
        if uploadedImage.image != nil {
            imageData = UIImagePNGRepresentation(uploadedImage.image!)!
        }
        assignedTasks.AddUpdateNewTask(imageData, ActivityId:activityId, TaskId: taskIds as String, UserId:userId, TaskName:taskName, TimeSpent:timespend , Comments:comments , CreatedDate:createdDates , ID: editId as String, view: self.view)
        
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
    func textViewDidBeginEditing(textView: UITextView) {
        commentPlaceholder.hidden = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImageView.hidden = false
            uploadedImage.contentMode = .ScaleToFill
            uploadedImage.image = pickedImage
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
}