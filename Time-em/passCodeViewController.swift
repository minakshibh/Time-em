//
//  passCodeViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 11/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import BKPasscodeView

class passCodeViewController:BKPasscodeViewController,BKPasscodeViewControllerDelegate {

    @IBOutlet var btnForgotPin: UIButton!
    @IBOutlet var txtFieldone: UITextField!
    @IBOutlet var txtFieldtwo: UITextField!
    @IBOutlet var txtFieldthree: UITextField!
    @IBOutlet var txtFieldFour: UITextField!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()      
//        txtFieldone.becomeFirstResponder()

        // The output below is limited by 1 KB.
        // Please Sign Up (Free!) to remove this limitation.
        
        var viewController: BKPasscodeViewController = BKPasscodeViewController(nibName: nil, bundle: nil)
        viewController.delegate = self
        viewController.type = BKPasscodeViewControllerNewPasscodeType
        viewController.passcodeStyle = BKPasscodeInputViewNumericPasscodeStyle
        viewController.touchIDManager = BKTouchIDManager(keychainServiceName: "sample")
        viewController.touchIDManager.promptText = "Scan fingerprint to authenticate"
        // You can set prompt text.
        var navController: UINavigationController = UINavigationController(rootViewController: viewController)
        self.presentViewController(navController, animated: true, completion: { _ in })



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
    }

    
    
    
    // MARK: textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        //delegate method
        
        print("textFieldDidBeginEditing")
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
      let userInfo = ["response" : textField]
        NSNotificationCenter.defaultCenter().postNotificationName("keyPressed", object: nil, userInfo: userInfo)
        
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        print("textFieldShouldEndEditing")
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        print("textFieldShouldReturn")
        return true
    }

    var passcode:String!
    var lockUntilDate:NSDate!
    var failedAttempts:Int!
    
    func passcodeViewController(aViewController: BKPasscodeViewController!, authenticatePasscode aPasscode: String!, resultHandler aResultHandler: ((Bool) -> Void)!) {
        if (aPasscode == self.passcode) {
            self.lockUntilDate = nil
            self.failedAttempts = 0
            aResultHandler(true)
        }
        else {
            aResultHandler(false)
        }
    }

    func passcodeViewControllerDidFailAttempt(aViewController: BKPasscodeViewController!) {
        if self.failedAttempts > 5 {
            var timeInterval: NSTimeInterval = 60
            if self.failedAttempts > 6 {
                var multiplier: Int = self.failedAttempts - 6
                timeInterval = (5 * 60)
                if timeInterval > 3600 * 24 {
                    timeInterval = 3600 * 24
                }
            }
            self.lockUntilDate = NSDate(timeIntervalSinceNow: timeInterval)
        }

    }

    func passcodeViewControllerNumberOfFailedAttempts(aViewController: BKPasscodeViewController!) -> UInt {
        return 3
    }
    
    func passcodeViewControllerLockUntilDate(aViewController: BKPasscodeViewController) -> NSDate {
        return self.lockUntilDate
    }
    func passcodeViewController(aViewController: BKPasscodeViewController!, didFinishWithPasscode aPasscode: String!) {
        switch aViewController.type {
            
        case BKPasscodeViewControllerNewPasscodeType, BKPasscodeViewControllerChangePasscodeType:
            self.passcode = aPasscode
            self.failedAttempts = 0
            self.lockUntilDate = nil
        default:
            break
        }
        
        aViewController.dismissViewControllerAnimated(true, completion: { _ in })

    }
}
