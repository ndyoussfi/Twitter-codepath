//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var UserBiggerPicture: UIImageView!
    @IBOutlet weak var UserProfilePicture: UIImageView!
    @IBOutlet weak var UserUserNameLabel: UILabel!
    @IBOutlet weak var UserTwitterNameLabel: UILabel!
    @IBOutlet weak var UserCountFollowing: UILabel!
    @IBOutlet weak var UserCountFollowers: UILabel!
    @IBOutlet weak var UserTaglineLabel: UILabel!
    
    
    var tweet: Tweet?
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserProfilePicture.setImageWithURL(NSURL(string: (tweet!.user?.profileImageUrl)!)!)
        UserUserNameLabel.text = "\((tweet!.user?.name)!)"
        UserTwitterNameLabel.text = "@\(tweet!.user!.screenname!)"
        UserCountFollowers.text = "\(tweet!.user!.followedBy!)"
        UserCountFollowing.text = "\(tweet!.user!.following!)"
        UserTaglineLabel.text = tweet!.user!.tagline!
        if (tweet!.user!.profileBannerURL != nil){
            let imageUrl = tweet!.user!.profileBannerURL!
            UserBiggerPicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
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
