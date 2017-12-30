//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class Tweet {
    
    var id: Int?
    var profileUrl: URL?
    var user: User?
    var text: String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var timestamp: Date?
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        
        // Picture
        let profileUrlString = (dictionary["user"] as! NSDictionary)["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        // User
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        // Counts
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        print(dictionary)
        
        // Timestamp
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

