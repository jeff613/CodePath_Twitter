//
//  NewTweetViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/22/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ContentView: UITextView!
    
    var replyTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.currentUser {
            NameLabel.text = user.name
            if let url = user.profileImageUrl {
                ProfileImageView.setImageWithURL(NSURL(string: url))
            }
        }
        
        if let screenName = replyTweet?.user?.screenName {
            ContentView.text = "@\(screenName) "
        } else {
            ContentView.text = ""
        }
        
        ContentView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSend(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(ContentView.text, replyToId: replyTweet?.id, callback: {
            (response: AnyObject?, error: NSError?) -> Void in
            if let response: AnyObject = response {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
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
