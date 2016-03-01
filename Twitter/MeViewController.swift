//
//  MeViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate {
    
    //@IBOutlet weak var MeBiggerPicture: UIImageView!
    //@IBOutlet weak var MeProfilePicture: UIImageView!
    //@IBOutlet weak var MeUserNameLabel: UILabel!
    //@IBOutlet weak var MeTwitterNameLabel: UILabel!
    //@IBOutlet weak var MeCountFollowing: UILabel!
    //@IBOutlet weak var MeCountFollowers: UILabel!
    //@IBOutlet weak var MeTaglineLabel: UILabel!
    
    
    
    @IBOutlet weak var backgroundImage: UIImageView! //
    @IBOutlet weak var profileImage: UIImageView! //
    @IBOutlet weak var userNameLabel: UILabel! //
    @IBOutlet weak var twitterNameLabel: UILabel! //
    @IBOutlet weak var followingCount: UILabel! //
    @IBOutlet weak var followersCount: UILabel! //
    @IBOutlet weak var taglineLabel: UILabel! //
    
    
    
    var tweets: [Tweet]?
    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.setImageWithURL(NSURL(string: (User.currentUser!.profileImageUrl)!)!)
       userNameLabel.text = "\((User.currentUser!.name)!)"
       twitterNameLabel.text = "@\(User.currentUser!.screenname!)"
        followersCount.text = "\(User.currentUser!.followedBy!)"
        followingCount.text = "\(User.currentUser!.following!)"
        taglineLabel.text = User.currentUser!.tagline!
        if (User.currentUser!.profileBannerURL != nil){
            let imageUrl = User.currentUser!.profileBannerURL!
            backgroundImage.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        
        
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
