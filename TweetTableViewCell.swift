//
//  Tweet.swift
//  Smashtag
//
//  Created by Aaron Grau on 10/28/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    var tweet: Tweet?{
        didSet{
            updateUI()
        }
    }
    
    
    private func updateUI(){
        
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet{
            
            var styleableText : NSMutableAttributedString = NSMutableAttributedString(string: "\(tweet.text)")
            for keyword in tweet.hashtags{styleableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: keyword.nsrange)}
            for keyword in tweet.userMentions{styleableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: keyword.nsrange)}
            for keyword in tweet.urls{styleableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: keyword.nsrange)}
            tweetTextLabel?.attributedText = styleableText
            tweetScreenNameLabel?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL{
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL){
                        dispatch_async(dispatch_get_main_queue()){
                            if profileImageURL == tweet.user.profileImageURL{
                                self.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
        }
    }
}
    

