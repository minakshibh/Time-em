//
//  passCodeViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import Toast_Swift

class passCodeViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var btnForgotPin: UIButton!
    @IBOutlet var txtFieldone: UITextField!
    @IBOutlet var txtFieldtwo: UITextField!
    @IBOutlet var txtFieldthree: UITextField!
    @IBOutlet var txtFieldFour: UITextField!
    var timer:NSTimer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()      
//        txtFieldone.becomeFirstResponder()

        // The output below is limited by 1 KB.
        // Please Sign Up (Free!) to remove this limitation.
        
        txtFieldone.becomeFirstResponder()
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(passCodeViewController.goPrevious), name: "deletePressed", object: nil)


        
        
    }
    override func viewWillAppear(animated: Bool) {
        txtFieldone.text = ""
        txtFieldtwo.text = ""
        txtFieldthree.text = ""
        txtFieldFour.text = ""
        txtFieldone.becomeFirstResponder()
    }
    
    func goPrevious() {
        if txtFieldtwo.isFirstResponder() {
            
            txtFieldone.becomeFirstResponder()
        } else if txtFieldthree.isFirstResponder() {
            
            txtFieldtwo.becomeFirstResponder()
        } else if txtFieldFour.isFirstResponder() {
            
            txtFieldthree.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnForgotPin(sender: AnyObject) {
        let resetPinAndPasswordView = resetPinAndPassword()
       
//        self.navigationController?.pushViewController(resetPinAndPasswordView, animated: true)
    }

    
    
    
    // MARK: textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        //delegate method
        
        print("textFieldDidBeginEditing")
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
      let userInfo = ["response" : textField]
        if textField == txtFieldone{
            print(txtFieldone.text)
            if txtFieldone.text?.characters.count > 0 {
                if string == "" {
                    txtFieldone.text = ""
                    
                }else{
                self.txtFieldtwo.text = ""
                self.txtFieldtwo.becomeFirstResponder()
                }
            }else {
            main {
                self.txtFieldtwo.becomeFirstResponder()
            }
           }
        }else if textField == txtFieldtwo{
            if txtFieldtwo.text?.characters.count > 0 {
                if string == "" {
                  txtFieldtwo.text = ""
                    
                }else{
                self.txtFieldthree.text = ""
                self.txtFieldthree.becomeFirstResponder()
                }
            }else {
            main {
                self.txtFieldthree.becomeFirstResponder()
            }
           }
        }else if textField == txtFieldthree{
            if txtFieldthree.text?.characters.count > 0 {
                if string == "" {
                    txtFieldthree.text = ""
                    
                }else{
                self.txtFieldFour.text = ""
               self.txtFieldFour.becomeFirstResponder()
                    self.txtFieldFour.resignFirstResponder()
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(passCodeViewController.callFunction), userInfo: nil, repeats: false)
                }
            }else {
            main {
                self.txtFieldFour.becomeFirstResponder()
            }
           }
        }else if textField == txtFieldFour{
            if txtFieldFour.text?.characters.count > 0 {
                if string == "" {
                    txtFieldFour.text = ""
                    
                }else{
               self.txtFieldFour.resignFirstResponder()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(passCodeViewController.callFunction), userInfo: nil, repeats: false)
                }
            }else {
            main {
                self.txtFieldFour.resignFirstResponder()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(passCodeViewController.callFunction), userInfo: nil, repeats: false)
                }
            }
        }
        return true
    }
    
    func callFunction()  {
        loginThroughPasscode()
    }
    
    
    
    func loginThroughPasscode () {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(passCodeViewController.displayResponse), name: "com.time-em.passcodeloginResponse", object: nil)

        
    let password = "\(txtFieldone.text!)\(txtFieldtwo.text!)\(txtFieldthree.text!)\(txtFieldFour.text!)"
        
        if Reachability.isConnectedToNetwork() == true {
            let currentUser_LoginId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as? String
            let api = ApiRequest()
            api.loginThroughPasscode(currentUser_LoginId!, SecurityPin: password, view: self.view)
        }else{
            if     NSUserDefaults.standardUserDefaults().valueForKey("currentUser_Pin") != nil {
                let passCode: String =  "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_Pin")!)"
                if passCode == password {
                    self.performSegueWithIdentifier("companyView", sender: self)
                }else{
//                view.makeToast("Worng passcode entered. Please try again.")
                    view.makeToast("Worng passcode entered. Please try again.", duration: 2, position: .Top)
                    txtFieldone.text = ""
                    txtFieldtwo.text = ""
                    txtFieldthree.text = ""
                    txtFieldFour.text = ""
                     txtFieldone.becomeFirstResponder()
                }
            }else{
                txtFieldone.text = ""
                txtFieldtwo.text = ""
                txtFieldthree.text = ""
                txtFieldFour.text = ""
                view.makeToast("Internet Connection not working.", duration: 2, position: .Top)
                txtFieldone.becomeFirstResponder()
            }
        }
    
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        print("textFieldShouldEndEditing")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        print("textFieldShouldReturn")
        return true
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        txtFieldone.text = ""
        txtFieldtwo.text = ""
        txtFieldthree.text = ""
        txtFieldFour.text = ""
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.passcodeloginResponse", object:nil)

        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            self.performSegueWithIdentifier("companyView", sender: self)
            
        }else{
            alert = UIAlertController(title: "Time'em", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
            txtFieldone.becomeFirstResponder()
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "companyView"{
            let compView = (segue.destinationViewController as! ChooseCompanyViewController)
            compView.fromView = "passCode"
            
            
        }else if segue.identifier == "resetPin"{
            let destinationVC = segue.destinationViewController as! resetPinAndPassword
            destinationVC.resetType = "Pin"
        }
    }

    
//    let loginVC: UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("loginView")
//    self.navigationController?.pushViewController(loginVC!, animated: true)
    

    }
