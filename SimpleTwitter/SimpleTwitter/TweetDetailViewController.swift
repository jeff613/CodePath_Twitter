//
//  TweetDetailViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/22/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tweet = tweet {
            NameLabel.text = tweet.user?.name
            ContentLabel.text = tweet.text
            if let url = tweet.user?.profileImageUrl {
                ProfileImageView.setImageWithURL(NSURL(string: url))
            }
            TimeLabel.text = tweet.createdAtLong
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance.retweet(id, callback: nil)
        }
    }

    @IBAction func onReply(sender: AnyObject) {
        var vc = storyboard?.instantiateViewControllerWithIdentifier("NewTweetView") as NewTweetViewController
        vc.replyTweet = tweet
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance.favorite(id, callback: nil)
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
