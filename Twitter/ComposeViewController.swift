//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var ComposeProfilePicture: UIImageView!
//    @IBOutlet weak var ComposeDismissButton: UIButton!
    @IBOutlet weak var ComposeUserNameLabel: UILabel!
    @IBOutlet weak var ComposeTwitterNameLabel: UILabel!
    @IBOutlet weak var ComposeTwitterButton: UIButton!
    @IBOutlet weak var ComposeLetterCountsLabel: UILabel!
    @IBOutlet weak var ComposeTextView: UITextView!
    @IBOutlet weak var initialTextLabel: UILabel!
    
    
    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
            ComposeProfilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        ComposeUserNameLabel.text = "\((user?.name)!)"
        ComposeTwitterNameLabel.text = "@\(user!.screenname!)"
        ComposeTextView.delegate = self
        ComposeLetterCountsLabel.text = "140"
        initialTextLabel.text = "Tweet Here ...."
        initialTextLabel.sizeToFit()
        ComposeTextView.addSubview(initialTextLabel)
        initialTextLabel.hidden = !ComposeTextView.text.isEmpty
        ComposeTextView.becomeFirstResponder()
        ComposeTwitterButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidChange(textView: UITextView) {
        initialTextLabel.hidden = !ComposeTextView.text.isEmpty
        if  0 < (141 - ComposeTextView.text!.characters.count) {
            ComposeTwitterButton.enabled = true
            ComposeLetterCountsLabel.text = "\(140 - ComposeTextView.text!.characters.count)"
        }
        else{
            ComposeTwitterButton.enabled = false
            ComposeLetterCountsLabel.text = "\(140 - ComposeTextView.text!.characters.count)"
        }
    }
    
    
    
    @IBAction func OnWriteTweet(sender: AnyObject) {
        tweetMessage = ComposeTextView.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
            TwitterClient.sharedInstance.composeWithCompletion(TweetMessage!, params: nil, completion: { (error) -> () in
                print(error)
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
