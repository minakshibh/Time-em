//
//  passCodeViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit

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



    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func keyPressed(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo!
        let textField: UITextField = (userInfo["response"] as! UITextField)
        
        if textField == txtFieldone{
            
            txtFieldtwo.becomeFirstResponder()
            
            
        }else if textField == txtFieldtwo{
            
            txtFieldthree.becomeFirstResponder()
            
        }else if textField == txtFieldthree{
            
            txtFieldFour.becomeFirstResponder()
            
        }else if textField == txtFieldFour{
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnForgotPin(sender: AnyObject) {
        let resetPinAndPasswordView = resetPinAndPassword()
       
        self.navigationController?.pushViewController(resetPinAndPasswordView, animated: true)
    }

    
    
    
    // MARK: textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        //delegate method
        
        print("textFieldDidBeginEditing")
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
      let userInfo = ["response" : textField]
        NSNotificationCenter.defaultCenter().postNotificationName("keyPressed", object: nil, userInfo: userInfo)
        if textField == txtFieldone{
            main {   self.txtFieldtwo.becomeFirstResponder() }
        }else if textField == txtFieldtwo{
            main {    self.txtFieldthree.becomeFirstResponder() }
        }else if textField == txtFieldthree{
            main {    self.txtFieldFour.becomeFirstResponder() }
        }else if textField == txtFieldFour{
            main {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(passCodeViewController.callFunction), userInfo: nil, repeats: false)
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
    let currentUser_LoginId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as? String
        let api = ApiRequest()
        api.loginThroughPasscode("admin", SecurityPin: password, view: self.view)
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
        
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            self.performSegueWithIdentifier("passcode_dashboard", sender: self)
            
        }else{
            alert = UIAlertController(title: "Time'em", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "resetPin"{
            let destinationVC = segue.destinationViewController as! resetPinAndPassword
            destinationVC.resetType = "Pin"
        }
    }
}
