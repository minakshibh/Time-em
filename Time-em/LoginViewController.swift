//
//  LoginViewController.swift
//  Time'em
//
//  Created by Krishna Mac Mini 2 on 10/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import FMDB

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet var imageLogo: UIImageView!
    @IBOutlet var txtUserID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var imageUserID: UIImageView!
    @IBOutlet var imagePassword: UIImageView!
    @IBOutlet var seperatorUserID: UILabel!
    @IBOutlet var sepratorPassword: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    var webData:NSMutableData!
    var currentUser: User!
    let notificationKey = "com.time-em.loginResponse"
    
    // MARK: defaults methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserID.delegate = self
        txtPassword.delegate = self
        
        btnLogin.layer.cornerRadius = 4
    }
    override func viewWillAppear(animated: Bool) {
        print("\(NSUserDefaults.standardUserDefaults().valueForKey("userLoggedIn"))")
        
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
    if (NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") != nil){
                delay(0.001){
                self.performSegueWithIdentifier("login_passcode", sender: self)
                            }
        }
            
      }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    @IBAction func btnLogin(sender: AnyObject) {
        self.login()
    }
    
    @IBAction func btnForgotPassword(sender: AnyObject) {
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    
    
    // MARK: textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
//        if textField == txtUserID {
//            txtUserID.becomeFirstResponder()
//        }else if textField == txtPassword{
//            txtPassword.becomeFirstResponder()
//        }
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        if textField == txtUserID{
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword{
            self.login()
        }
        
        return true
    }
    
    
    // MARK: functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserID.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    func login() {
        let userIDStr: String = txtUserID.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let passwordStr: String = txtPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
//        var message:String = ""
//        if userIDStr.isEmpty {
//            message = "Please enter userID"
//            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//        }else if passwordStr.isEmpty{
//            message = "Please enter password"
//            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//        }
//        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.displayResponse), name: notificationKey, object: nil)
    
        let loginUser = ApiRequest()
//        let status:Bool = loginUser.loginApi(userIDStr, password: passwordStr)
        loginUser.loginApi("admin", password: "training",view: self.view)
        
        
      
 
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)

        var alert :UIAlertController!
        if status.lowercaseString == "success"{
         alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            self.performSegueWithIdentifier("homeView", sender: self)
        
        }else{
         alert = UIAlertController(title: "Time'em", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeView"{
        
        }
    }
    func getCurrentUser() {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            
            let rs = try database.executeQuery("select * from userdata", values: nil)
            while rs.next() {
                let x = rs.stringForColumn("userId")
                let y = rs.dataForColumn("userData")
                let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableDictionary
                print(userDict)
                self.currentUser =  User(dict: userDict)
                
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }

}
