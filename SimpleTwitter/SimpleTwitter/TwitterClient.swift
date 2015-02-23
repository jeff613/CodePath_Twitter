//
//  TwitterClient.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/21/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

let twitterConsumerKey = "6VuPNxH8c0xvzDd7NQsOdHkdz"
let twitterConsumerSecret = "fco8JtA0BQ0qZffwzgw7row1Vc24DmjVNz5TvrsqAJ91O1bIht"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

let userLoginNotification = "userLoginNotification"

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCallback: ((User?, NSError?) -> Void)?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCallback(callback: (user: User?, error: NSError?) -> Void ) {
        loginCallback = callback
        // Fetch request token and redirect to twitter
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "jefftwitter://oauth"), scope: nil, success: { (requestCredential: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestCredential.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }, failure: { (error: NSError!) -> Void in
                println("Error getting request token: \(error)")
                self.loginCallback?(nil, error)
        })
    }
    
    func openURL(url: NSURL) {
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (credential: BDBOAuth1Credential!
            ) -> Void in
            println("Got the access token: \(credential.token)")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(credential)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user: \(response)")
                var user = User(dict: response as NSDictionary)
                User.currentUser = user
                NSNotificationCenter.defaultCenter().postNotificationName(userLoginNotification, object: nil)
                println("user: \(user.name)")
                self.loginCallback?(user, nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting user: \(error)")
                    self.loginCallback?(nil, error)
            })
            }) { (error: NSError!) -> Void in
                println("Failed to get access token")
                self.loginCallback?(nil, error)
        }
    }
    
    func getHomeTweets(callback: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("home: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            callback(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting user: \(error)")
                callback(tweets: nil, error: error)
        })
    }
    
    func tweet(text: String, replyToId: Int?, callback: ((response: AnyObject?, error: NSError?) -> Void)?) {
        var param = [String: AnyObject]()
        param["status"] = text
        if let id = replyToId {
            param["in_reply_to_status_id"] = replyToId
        }
        POST("1.1/statuses/update.json", parameters: param, success: { (opertaion: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("tweet response: \(response)")
            callback?(response: response, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                callback?(response: nil, error: error)
        }
    }
    
    func retweet(tweetId: Int, callback: ((response: AnyObject?, error: NSError?) -> Void)?) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: { (opertaion: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("retweet response: \(response)")
            callback?(response: response, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                callback?(response: nil, error: error)
        }
    }
    
    func favorite(tweetId: Int, callback: ((response: AnyObject?, error: NSError?) -> Void)?) {
        var param = [String: AnyObject]()
        param["id"] = tweetId
        POST("1.1/favorites/create.json", parameters: param, success: { (opertaion: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("fav response: \(response)")
            callback?(response: response, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                callback?(response: nil, error: error)
        }
    }
}
