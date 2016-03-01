//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//


import UIKit

class TweetsTableViewCell: UITableViewCell {
    
// Edit them all
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetContentText: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    
    
    
    
    var tweetID: String = ""
    var  isRetweetButton: Bool = false
    var islikeButton: Bool = false
    var tweet: Tweet! {
        didSet {
        tweetContentText.text = tweet.text
        userName.text = "\((tweet.user?.name)!)"
        userHandle.text = "@\(tweet.user!.screenname!)"
        if (tweet.user?.profileImageUrl != nil){
            let imageUrl = tweet.user?.profileImageUrl!
            profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            print("No Picture")
        }
        retweetCount.text = String(tweet.retweetCount!)
        favoriteCount.text = String(tweet.likeCount)
        tweetID = tweet.id
        retweetCount.text! == "0" ? (retweetCount.hidden = true) : (retweetCount.hidden = false)
        favoriteCount.text! == "0" ? (favoriteCount.hidden = true) : (favoriteCount.hidden = false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        profileImage.layer.cornerRadius = 4
        profileImage.clipsToBounds = true
        self.retweetButton.setImage(UIImage(named: "Retweet-Green"), forState: UIControlState.Selected)
        self.favoriteButton.setImage(UIImage(named: "Like-Red"), forState: UIControlState.Selected)
        tweetContentText.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
    }
    
    
    
    @IBAction func WhenRetweeting(sender: AnyObject) {
        if self.isRetweetButton {

            self.retweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
            
            if self.retweetCount.text! <= "0" {
                self.retweetCount.hidden = true
                self.isRetweetButton = false
            } else{
                TwitterClient.sharedInstance.unretweetWithCompletion(Int(tweetID)!, params: nil, completion: {(error) -> () in
                self.retweetCount.hidden = false
                self.tweet.retweetCount!--
                self.isRetweetButton = false
                self.retweetCount.textColor = UIColor.blackColor()
                self.retweetCount.text = "\(self.tweet.retweetCount!)"
                })
            }
            
        } else {
            
            TwitterClient.sharedInstance.retweetWithCompletion(Int(tweetID)!, params: nil, completion: {(error) -> () in
                self.retweetButton.setImage(UIImage(named: "Retweet-Green"), forState: UIControlState.Normal)
                self.retweetCount.hidden = false
                self.isRetweetButton = true
                self.tweet.retweetCount!++
                self.retweetCount.textColor = UIColor(red: 0, green: 0.949, blue: 0.0314, alpha: 1.0)
                self.retweetCount.text = "\(self.tweet.retweetCount!)"
                
            })
           
        }
        if self.retweetCount.text! <= "0" {
            self.retweetCount.hidden = true
        } else {
            self.retweetCount.hidden = false
        }
    }
    
    
    
    @IBAction func WhenLike(sender: AnyObject) {
         TwitterClient.sharedInstance.favoriteWithCompletion(Int(tweetID)!, params: nil, completion: {(error) -> () in
        if self.islikeButton {
            self.favoriteCount.text = String(self.tweet.likeCount);self.favoriteButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
             if self.favoriteCount.text! == "0" {
                self.favoriteCount.hidden = true
             } else{
                self.favoriteCount.hidden = false
                self.tweet.likeCount--
                 self.islikeButton = false
                self.favoriteCount.textColor = UIColor.blackColor()
                self.favoriteCount.text = "\(self.tweet.likeCount)"
            }
        }
        else{
            self.favoriteButton.setImage(UIImage(named: "Like-Red"), forState: UIControlState.Normal)
            self.favoriteCount.hidden = false
            self.islikeButton = true
            self.tweet.likeCount++
            self.favoriteCount.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0)
            self.favoriteCount.text = "\(self.tweet.likeCount)"
            
        }
            if self.favoriteCount.text! == "0" {
                self.favoriteCount.hidden = true
            } else {
                self.favoriteCount.hidden = false
            }
         })
    }
        
     override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
