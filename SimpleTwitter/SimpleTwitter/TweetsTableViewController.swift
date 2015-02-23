//
//  TweetsTableViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/21/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController {

    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadTweets"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        //loadTweets()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadTweets()
    }
    
    func loadTweets() {
        tweets = []
        tableView.reloadData()
        
        TwitterClient.sharedInstance.getHomeTweets({ (tweets: [Tweet]?, error: NSError?) -> Void in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var vc = storyboard?.instantiateViewControllerWithIdentifier("NewTweetView") as NewTweetViewController
        presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
        
        cell.setup(tweets[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = storyboard?.instantiateViewControllerWithIdentifier("TweetDetailView") as TweetDetailViewController
        vc.tweet = tweets[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
