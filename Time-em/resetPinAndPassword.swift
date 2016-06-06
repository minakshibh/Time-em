
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
    @IBAction func send(sender: AnyObject) {
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
            alert = UIAlertController(title: "Time'em", message: "Reset Failed", preferredStyle: UIAlertControllerStyle.Alert)
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