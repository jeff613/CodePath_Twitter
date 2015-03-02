//
//  MentionsViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 3/1/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class MentionsViewController: TweetsTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadTweets() {
        tweets = []
        tableView.reloadData()
        
        TwitterClient.sharedInstance.getMentionTweets({ (tweets: [Tweet]?, error: NSError?) -> Void in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
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
