//
//  User.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/21/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import Foundation

var _currentUser: User?
let userKey = "current_user_data"
let userLogoutNotification = "userLogoutNotification"

class User {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    
    var dict: NSDictionary
    
    init(dict: NSDictionary) {
        self.dict = dict
        
        name = dict["name"] as? String
        screenName = dict["screen_name"] as? String
        profileImageUrl = dict["profile_image_url"] as? String
        tagLine = dict["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(userKey) as? NSData
                if let data = data {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dict: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dict, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: userKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: userKey)
            }
        }
    }
}