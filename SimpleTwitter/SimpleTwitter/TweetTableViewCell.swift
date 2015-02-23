//
//  TweetTableViewCell.swift
//  SimpleTwitter
//
//  Created by Jianfeng Ye on 2/22/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func onReply(tweet: Tweet?)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    var tweet: Tweet?
    
    var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onReply(sender: AnyObject) {
        delegate?.onReply(tweet)
    }

    @IBAction func onRetweet(sender: AnyObject) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance.retweet(id, callback: nil)
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let id = tweet?.id {
            TwitterClient.sharedInstance.favorite(id, callback: nil)
        }
    }
    
    func setup(t: Tweet) {
        tweet = t
        NameLabel.text = tweet?.user?.name
        ContentLabel.text = tweet?.text
        if let url = tweet?.user?.profileImageUrl {
            ProfileImageView.setImageWithURL(NSURL(string: url))
        }
        TimeLabel.text = tweet?.createdAtShort
    }
}
