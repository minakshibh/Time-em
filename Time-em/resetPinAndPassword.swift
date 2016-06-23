
import Foundation

class resetPinAndPassword: UIViewController
{
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var resetInfoLbl: UILabel!
    @IBOutlet var titleBar: UILabel!
     @IBOutlet var btnSend: UIButton!
    
    
    let passwordNotificationKey = "com.time-em.resetPassword"
    let pinNotificationKey = "com.time-em.resetPin"
    
    var resetType:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if resetType == "Password" {
            resetInfoLbl.text = "Enter your email to reset your password."
            titleBar.text = "Forgot Password?"
        }else{
            resetInfoLbl.text = "Enter your email to reset your pin."
            titleBar.text = "Forgot Pin?"
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        btnSend.layer.cornerRadius = 4
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    @IBAction func send(sender: AnyObject) {
        let emailStr: String = self.emailTxt.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if emailStr.characters.count == 0 {
           let message = "Please enter an emailaddress."
            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else if !isValidEmail(emailStr){
            let message = "Enter a valid emailaddress."
            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        let emailIs = self.emailTxt.text!
      
        let assignedTasks = ApiRequest()
        
        if resetType == "Password" {
            assignedTasks.resetPasswordApi(emailIs, view: self.view)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetPinAndPassword.displayResponse), name: passwordNotificationKey, object: nil)
        }else{
            assignedTasks.resetPinApi(emailIs, view: self.view)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetPinAndPassword.displayResponse), name: pinNotificationKey, object: nil)
        }
    }
    
    func displayResponse(notification:NSNotification) {
        self.emailTxt.text = ""
        
        if resetType == "Password" {
            NSNotificationCenter.defaultCenter().removeObserver(self, name:passwordNotificationKey, object:nil)
        }else{
            NSNotificationCenter.defaultCenter().removeObserver(self, name:pinNotificationKey, object:nil)
        }


        var messages: String!
        if resetType == "Password" {
            messages = "Password has been sent to your email address."
        }else{
            messages = "Pin has been sent to your email address."
        }
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        var alert :UIAlertController!
        if status.lowercaseString == "success"{
            alert = UIAlertController(title: "Time'em", message: messages, preferredStyle: UIAlertControllerStyle.Alert)
            
        }else{
            alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        delay(0.001) {
        self.dismissViewControllerAnimated(true, completion: {})
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}