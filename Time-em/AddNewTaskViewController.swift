//
//  AddNewTaskViewController.swift
//  Time-em
//
//  Created by Krishna_Mac_4 on 19/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation

class AddNewTaskViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet var taskDropDown: UIButton!
    @IBOutlet var selectTaskTxt: UITextField!
    @IBOutlet var commentsTxt: UITextView!
    @IBOutlet var commentPlaceholder: UILabel!
    @IBOutlet var numberOfHoursTxt: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadBtn.layer.cornerRadius = 5
        
//        let assignedTasks = ApiRequest()
        
//        assignedTasks.GetAssignedTaskIList(<#T##userId: String##String#>, view: <#T##UIView#>)
        
        dropDown.dataSource = [
            "Add New Task"
        ]
        
        //~~ Add Value to textfield from dropdown
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            if index == 0 {
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
    
//~~ TextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        commentPlaceholder.hidden = true
    }
}