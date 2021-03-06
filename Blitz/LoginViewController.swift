//
//  LoginViewController.swift
//  Blitz
//
//  Created by ccccccc on 15/10/4.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if(isLoggedIn == 1){
            self.performSegueWithIdentifier("Login", sender: self)
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Should jump to homepage")
            
            //thread for notification
            if let username:NSString = prefs.stringForKey("USERNAME") {
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): This is run on the background queue")
                    while true {
                        let jsonObject: [String: AnyObject] = [
                            "operation": "GetNotifications",
                            "username": username
                        ]

                        let result = getResultFromServerAsJSONObject(jsonObject)
                        let resultJSON = JSON(result)
                        if let msg = resultJSON["msg"].string {
                            notificaitonCreate(msg)
                        }
                        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Background thread running")
                        NSThread.sleepForTimeInterval(5)
                    }
                })
            }

        }
    }
    
    
    @IBAction func signinTapped(sender: UIButton) {
        // Authentication Code
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            let alertController = UIAlertController(title: "Sign Up Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        } else {
            
            // Make a json object for communication with server
            let jsonObject: [String: AnyObject] = [
                "operation": "Login",
                "username": username,
                "password": password
            ]
            
            let result = getResultFromServerAsJSONObject(jsonObject)
            
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Result = ", result)
            
            if(result["success"] as! Bool){
                NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Login SUCCESS");
                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject(username, forKey: "USERNAME")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                prefs.synchronize()
                
                self.performSegueWithIdentifier("Login", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Sign Up Failed!", message: result["msg"] as? String, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) {}
            }
            
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
