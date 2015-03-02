//
//  ProfileViewController.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 3/1/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var TweetsCountLabel: UILabel!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = User.currentUser
        }
        
        if let user = user {
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            bgImageView.setImageWithURL(NSURL(string: user.profileBGImageUrl!))
            nameLabel.text = user.name
            followersCountLabel.text = String(user.followersCount!)
            followingsCountLabel.text = String(user.followsCount!)
            TweetsCountLabel.text = String(user.tweetsCount!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onMenu(sender: AnyObject) {
        let menuToggler = navigationController?.parentViewController as ContainerViewController
        menuToggler.toggleMenu()
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
