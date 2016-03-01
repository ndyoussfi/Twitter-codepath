//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var ReplyProfilePicture: UIImageView!
    @IBOutlet weak var ReplyUserNameLabel: UILabel!
    @IBOutlet weak var ReplyTwitterNameLabel: UILabel!
    @IBOutlet weak var ReplyLetterCountsLabel: UILabel!
    @IBOutlet weak var ReplyTextView: UITextView!
    @IBOutlet weak var ReplyinitialTextLabel: UILabel!
    @IBOutlet weak var ReplyTheTweetButton: UIButton!

    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!
 //   var handleLabelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
            ReplyProfilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        ReplyUserNameLabel.text = "\((user?.name)!)"
        ReplyTwitterNameLabel.text = "@\(user!.screenname!)"
        ReplyTextView.delegate = self
        ReplyLetterCountsLabel.text = "140"
        ReplyTextView.text = "@\(tweet!.user!.screenname!)\n"
        ReplyTextView.becomeFirstResponder()
        ReplyTheTweetButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        if  0 < (141 - ReplyTextView.text!.characters.count) {
            ReplyTheTweetButton.enabled = true
            ReplyLetterCountsLabel.text = "\(140 - ReplyTextView.text!.characters.count)"
        }
        else{
            ReplyTheTweetButton.enabled = false
            ReplyLetterCountsLabel.text = "\(140 - ReplyTextView.text!.characters.count)"
        }
    }
    
    @IBAction func OnReplyTweet(sender: AnyObject) {
        tweetMessage = ReplyTextView.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        TwitterClient.sharedInstance.replyWithCompletion(TweetMessage!, statusID: Int(tweet!.id)!, params: nil, completion: { (error) -> () in
        })
        navigationController?.popViewControllerAnimated(true)
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
