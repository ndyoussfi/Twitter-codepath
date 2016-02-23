//
//  Tweet.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//


import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id: NSNumber? // check
    var favCount: NSNumber? // check
    var retweetCount: NSNumber? // check
    var retweetImage: UIImage? // check
    var favImage: UIImage? // check
    
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int // check
        favCount = dictionary["favorite_count"] as! Int // check
        retweetCount = dictionary["retweet_count"] as? Int // check
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)

        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    class func responseAsDictionary(dict: NSDictionary) -> Tweet {
        
        
        let tweet = Tweet(dictionary: dict)
        
        return tweet
    }
}
