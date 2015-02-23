//
//  Tweet.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/21/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import Foundation

class Tweet {
    var user: User?
    var id: Int?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    init(dict: NSDictionary) {
        user = User(dict: dict["user"] as NSDictionary)
        text = dict["text"] as? String
        createdAtString = dict["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        id = dict["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dict: dict))
        }
        
        return tweets
    }
    
    var createdAtLong: String {
        get {
            if let createdAt = createdAt {
                var df = NSDateFormatter()
                df.dateStyle = NSDateFormatterStyle.MediumStyle
                df.timeStyle = NSDateFormatterStyle.MediumStyle
                return df.stringFromDate(createdAt)
            } else {
                return ""
            }
        }
    }
    
    var createdAtShort: String {
        get {
            if let createdAt = createdAt {
                if NSCalendar.currentCalendar().isDateInToday(createdAt) {
                    var df = NSDateFormatter()
                    df.timeStyle = NSDateFormatterStyle.ShortStyle
                    return df.stringFromDate(createdAt)
                } else {
                    var df = NSDateFormatter()
                    df.dateStyle = NSDateFormatterStyle.ShortStyle
                    return df.stringFromDate(createdAt)
                }
            } else {
                return ""
            }
        }
    }
}