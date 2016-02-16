//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//


import UIKit

class TweetCell: UITableViewCell {
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetContentText: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    
    var tweet : Tweet! {
        didSet {
            tweetContentText.text = tweet.text
            userName.text = tweet.user?.name
            userHandle.text = "@\(tweet.user!.screenname!)" as String
            
            retweetCount.text = "\(tweet.retweetCount as! Int)"
            
            favoriteCount.text = "\(tweet.favCount as! Int)"
            print("This is the set fav count: \(favoriteCount.text)")
            
            if (tweet.user?.profileImageUrl != nil) {
                profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
            } else {
                print("No profile picture found")
            }
            
            replyImage.image = UIImage(named: "reply")
            
            

            createdTime.text = timeEdited(tweet.createdAt!.timeIntervalSinceNow)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 4.5
        profileImage.clipsToBounds = true
        retweetButton.setImage(UIImage(named: "retweet-clicked.png"), forState: UIControlState.Selected)
        
        favoriteButton.setImage(UIImage(named: "like-clicked.png"), forState: UIControlState.Selected)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    
    func timeEdited(timeTweetPostedAgo: NSTimeInterval) -> String {
       
        var tweetTime = Int(timeTweetPostedAgo)
        var time: Int = 0
        var char = ""
        
        tweetTime = tweetTime * (-1)
        

        if (tweetTime <= 60) { // SECONDS
            time = tweetTime
            char = "s"
        } else if ((tweetTime/60) <= 60) { // MINUTES
            time = tweetTime/60
            char = "m"
        } else if (tweetTime/60/60 <= 24) { // HOURS
            time = tweetTime/60/60
            char = "h"
        } else if (tweetTime/60/60/24 <= 365) { // DAYS
            time = tweetTime/60/60/24
            char = "d"
        } else if (tweetTime/(3153600) <= 1) { // YEARS
            time = tweetTime/60/60/24/365
            char = "y"
        }
        
        
        return "\(time)\(char)"
    }

}
