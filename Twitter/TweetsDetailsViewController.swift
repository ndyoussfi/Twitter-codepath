//
//  TweetsDetailsViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class TweetsDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var DetailsProfileImage: UIImageView!
    @IBOutlet weak var DetailUserNameLabel: UILabel!
    @IBOutlet weak var DetailTweeterNameLabel: UILabel!
    @IBOutlet weak var DetailCurrentTweetLabel: UILabel!
    @IBOutlet weak var DetailTimesTampLabel: UILabel!
    @IBOutlet weak var DetailNumberTweetsLabel: UILabel!
    @IBOutlet weak var DetailNumberFavoritesLabel: UILabel!
    @IBOutlet weak var DetailRetweetButton: UIButton!
    @IBOutlet weak var DetailLikesButton: UIButton!
    @IBOutlet weak var DetailReplyButton: UIButton!
    
    
    
    var tweet: Tweet?
    var dateFormatter = NSDateFormatter()
    var isRetweetButton: Bool = false
    var islikeButton: Bool = false
    var tweetID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetID = tweet!.id
        DetailCurrentTweetLabel.text = tweet!.text
        DetailUserNameLabel.text = "\((tweet!.user?.name)!)"
        DetailTweeterNameLabel.text = "@\(tweet!.user!.screenname!)"
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let dateString = dateFormatter.stringFromDate((tweet?.createdAt!)!)
        DetailTimesTampLabel.text = "\(dateString)"
        if (tweet?.user?.profileImageUrl != nil){
            let imageUrl = tweet!.user!.profileImageUrl!
            DetailsProfileImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        DetailNumberTweetsLabel.text = String(tweet!.retweetCount!)
        DetailNumberFavoritesLabel.text = String(tweet!.likeCount)
        DetailUserNameLabel.preferredMaxLayoutWidth = DetailUserNameLabel.frame.size.width
        DetailsProfileImage.layer.cornerRadius = 4
        DetailsProfileImage.clipsToBounds = true
        self.DetailRetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Selected)
        self.DetailLikesButton.setImage(UIImage(named: "Like"), forState: UIControlState.Selected)
        DetailCurrentTweetLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func WhenRetweetingInDetail(sender: AnyObject) {
        if self.isRetweetButton {
            self.DetailRetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
                TwitterClient.sharedInstance.unretweetWithCompletion(Int(tweetID)!, params: nil, completion: {(error) -> () in
                    self.DetailNumberTweetsLabel.hidden = false
                    self.tweet!.retweetCount!--
                    self.isRetweetButton = false
                    self.DetailNumberTweetsLabel.textColor = UIColor.blackColor()
                    self.DetailNumberTweetsLabel.text = "\(self.tweet!.retweetCount!)"
                })
        } else {
        if Int(tweetID) != nil {
            TwitterClient.sharedInstance.retweetWithCompletion( Int(tweetID)!, params: nil, completion: {(error) -> () in
                self.DetailRetweetButton.setImage(UIImage(named: "Retweet-Green"), forState: UIControlState.Normal)
                self.isRetweetButton = true
                self.tweet!.retweetCount!++
                self.DetailNumberTweetsLabel.textColor = UIColor(red: 0, green: 0.949, blue: 0.0314, alpha: 1.0)
                self.DetailNumberTweetsLabel.text = "\(self.tweet!.retweetCount!)"
                
            })
        } else {
            print("tweetID is nil")
        }
        }
    }
    
    
    
    @IBAction func WhenLikeInDetail(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletion(Int(tweetID)!, params: nil, completion: {(error) -> () in
            if self.islikeButton {
                self.DetailLikesButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.tweet!.likeCount--
                self.islikeButton = false
                self.DetailNumberFavoritesLabel.textColor = UIColor.blackColor()
                self.DetailNumberFavoritesLabel.text = "\(self.tweet!.likeCount)"
            }
            else{
                self.DetailLikesButton.setImage(UIImage(named: "Like-Red"), forState: UIControlState.Normal)
                self.islikeButton = true
                self.tweet!.likeCount++
                self.DetailNumberFavoritesLabel.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0)
                self.DetailNumberFavoritesLabel.text = "\(self.tweet!.likeCount)"
                
            }
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier) == "ReplyFromDetailSegue" {
            
            let user = User.currentUser
            let tweet = self.tweet
            let ReplyTweetViewController = segue.destinationViewController as! ReplyViewController
            ReplyTweetViewController.user = user
            ReplyTweetViewController.tweet = tweet
            
        } else if (segue.identifier) == "FromDetailToUserProfileSegue" {
            let user = User.currentUser
            let tweet = self.tweet
            let UserProfilePageViewController = segue.destinationViewController as! UserProfileViewController
            UserProfilePageViewController.user = user
            UserProfilePageViewController.tweet = tweet
        }

    }
    
    
    
    
}
