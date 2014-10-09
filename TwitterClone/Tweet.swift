//
//  Tweet.swift
//  TwitterClone
//
//  Created by Joshua Winskill on 10/6/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class Tweet {
    var text : String?
    var avatarImageURLString: String?
    var avatarImage : UIImage?
    var userName: String?
    var favorites: Int?
    var retweets: Int?
    var id: Int?
    var userID: String?
    
    init (tweetInfo: NSDictionary) {
        self.text = tweetInfo["text"] as? String
        let userDictionary = tweetInfo["user"] as? NSDictionary
        self.avatarImageURLString = userDictionary!["profile_image_url"] as? String
        self.userName = userDictionary!["name"] as? String
        self.favorites = tweetInfo["favorite_count"] as? Int
        self.retweets = tweetInfo["retweet_count"] as? Int
        self.id = tweetInfo["id"] as? Int
        self.userID = userDictionary!["id_str"] as? String
    }
    
    class func parseJSONDataIntoTweets (rawJSONData: NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            return tweets
        }
        return nil
    }
    
    class func parseJSONDataIntoIndividualTweet (rawJSONData: NSData) -> Tweet? {
        var error: NSError?
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            

            var newTweet : Tweet?
            newTweet = Tweet(tweetInfo: jsonDictionary)
            return newTweet
        }
        return nil
    }
}