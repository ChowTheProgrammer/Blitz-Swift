//
//  SignupViewController.swift
//  Blitz
//
//  Created by ccccccc on 15/10/4.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        let username:NSString = txtUsername.text!
        let email:NSString = txtEmail.text!
        let password:NSString = txtPassword.text!
        let confirm_password:NSString = txtConfirmPassord.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ||
            email.isEqualToString("") || confirm_password.isEqualToString(""))
        {
            let alertController = UIAlertController(title: "Sign Up Failed!", message: "Please enter Username, Email, Password and Confirm Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        }
        else if ( !password.isEqual(confirm_password) )
        {
            let alertController = UIAlertController(title: "Sign Up Failed!", message: "Passwords doesn't Match", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        }
        else
        {
            let post:String = "username=\(username)&password=\(password)&c_password=\(confirm_password)"
            
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): PostData: %@", post);
            
            // Make a json object for communication with server
            let signupJSONObject: [String: AnyObject] = [
                "operation": "Signup",
                "username": username,
                "password": password,
                "email" : email
            ]
            
            let result = getResultFromServerAsJSONObject(signupJSONObject)
            
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): %@", result)
            
            if (result["success"] as! Bool) {
                NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Sign Up SUCCESS")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Sign Up Failed!", message: result["msg"] as? String, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) {}
            }
            
        }
    }
    
    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
