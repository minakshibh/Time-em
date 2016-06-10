//
//  myProfileViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 07/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

class myProfileViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnEditprofile: UIButton!
    @IBOutlet var imageprofile: UIImageView!
    @IBOutlet var lblNameUnderprofileImage: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var btnLogOut: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var isEditModeEnable:Bool = false
    let labelColor = UIColor.lightGrayColor()
    let textFieldColor = UIColor.blackColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.textColor = labelColor
        lblEmail.textColor = labelColor
        lblPhoneNo.textColor = labelColor
        lblPassword.textColor = labelColor
        
        btnLogOut.setTitleColor(textFieldColor, forState: .Normal)
        
        txtName.textColor = textFieldColor
        txtEmail.textColor = textFieldColor
        txtPhoneNo.textColor = textFieldColor
        txtPassword.textColor = textFieldColor
        
        
        let numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        numberToolbar.barStyle = .BlackTranslucent
        numberToolbar.items = [UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(myProfileViewController.cancelNumberPad)), UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(myProfileViewController.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtPhoneNo.inputAccessoryView = numberToolbar

    }

    override func viewDidAppear(animated: Bool) {
        scrollView.scrollEnabled = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if Reachability.DeviceType.IS_IPHONE_5 {
//            scrollView.contentSize = CGSizeMake(320, 650)
        }
        scrollView.backgroundColor = UIColor.clearColor()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnEditprofile(sender: AnyObject) {
        
        if !isEditModeEnable {
            isEditModeEnable = true
            
            // unhide textfields
            txtName.hidden = false
            txtEmail.hidden = false
            txtPhoneNo.hidden = false
            txtPassword.hidden = false
        
            //hide labels
            lblName.hidden = true
            lblEmail.hidden = true
            lblPhoneNo.hidden = true
            lblPassword.hidden = true
        
            //assigning lbl value to textfields
            txtName.text = lblName.text
            txtEmail.text = lblEmail.text
            txtPhoneNo.text = lblPhoneNo.text
            txtPassword.text = lblPassword.text
            
             btnLogOut.setTitleColor(labelColor, forState: .Normal)
        }else{
            scrollView.scrollEnabled = false
            isEditModeEnable = false
            // unhide textfields
            txtName.hidden = true
            txtEmail.hidden = true
            txtPhoneNo.hidden = true
            txtPassword.hidden = true
            
            //hide labels
            lblName.hidden = false
            lblEmail.hidden = false
            lblPhoneNo.hidden = false
            lblPassword.hidden = false
            
            //assigning lbl value to textfields
            lblName.text = txtName.text
            lblEmail.text = txtEmail.text
            lblPhoneNo.text = txtPhoneNo.text
            lblPassword.text = txtPassword.text
            
            
             btnLogOut.setTitleColor(textFieldColor, forState: .Normal)
            
            
            //assigning value
            let name:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_FullName")!)"
            lblName.text = name
            lblNameUnderprofileImage.text = name
        }
        
    }
    @IBAction func btnLogOut(sender: AnyObject) {
    }
    @IBAction func resgnResponder(sender: AnyObject) {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder() 
        txtPhoneNo.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if Reachability.DeviceType.IS_IPHONE_5 || Reachability.DeviceType.IS_IPHONE_6 {
            scrollView.scrollEnabled = true
            scrollView.contentSize = CGSizeMake(320, 500)
            
            if textField == txtName {
                
            }else if textField == txtEmail {
                    scrollView.setContentOffset(CGPointMake(0, txtName.frame.size.height), animated: true)
            }else if textField == txtPassword {
                    scrollView.setContentOffset(CGPointMake(0, txtName.frame.size.height*2), animated: true)
            }else if textField == txtPhoneNo {
                    scrollView.setContentOffset(CGPointMake(0, txtName.frame.size.height*3), animated: true)
            }
            
        }
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        
        print(scrollView.contentOffset)
        return true
    }
   
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtName {
            if (string == "\n") {
                txtEmail.becomeFirstResponder()
                return true
            }
        }else if textField == txtEmail {
            if (string == "\n") {
                txtPassword.becomeFirstResponder()
                return true
            }
        }else if textField == txtPassword {
            if (string == "\n") {
                txtPhoneNo.becomeFirstResponder()
                return true
            }
        }else if textField == txtPhoneNo {
            if (string == "\n") {
                txtPhoneNo.resignFirstResponder()
                if scrollView.contentOffset.y == 200.0 {
                    self.automaticallyAdjustsScrollViewInsets = false
                }
                scrollView.contentSize = CGSizeMake(0, 0)
                return true
            }
        }
        return true
    }

    func cancelNumberPad() {
        txtPhoneNo.resignFirstResponder()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
        txtPhoneNo.text = ""
    }
    
    func doneWithNumberPad() {
        txtPhoneNo.resignFirstResponder()
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false

    }
}