//
//  ViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/21/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func OnLoginButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCallback { (user, error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("LoginSegue", sender: self)
            } else {
                
            }
        }
        
    }

}

