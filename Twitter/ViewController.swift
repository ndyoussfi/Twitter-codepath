//
//  ViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//


import UIKit
import AFNetworking
import BDBOAuth1Manager



class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {

        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                 self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle error
                  self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if User.currentUser != nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }

}

