//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Joshua Winskill on 10/8/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
    
    var twitterAccount: ACAccount?
    let imageQueue = NSOperationQueue()
    
    init () {
        self.imageQueue.maxConcurrentOperationCount = 6
    }
    
    
    // MARK: Timeline fetch methods
    
    func fetchHomeTimeline(userTweet: Tweet?, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as? ACAccount
                var url: NSURL?
                if userTweet != nil {
                    url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userTweet!.userID!)")
                } else {
                    url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                }
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            let tweets = Tweet.parseJSONDataIntoTweets(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweets: tweets)
                                //self.tableView.reloadData()
                                //self.tableView.rowHeight = UITableViewAutomaticDimension
                            })
                            //right here, we are on a background queue (AKA Thread)
                        case 400...499:
                            println("This is the client's fault")
                            completionHandler(errorDescription: "This was your fault", tweets: nil)
                        case 500...599:
                            println("This is the server's fault")
                            completionHandler(errorDescription: "This is the server's fault", tweets: nil)
                        default:
                            println("Something bad happened")
                        }
                    }
                })
            }
        }
    }
    
    func fetchRefreshedTweets(stringForHomeOrUser: String, newestTweet: Tweet?, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as? ACAccount
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/\(stringForHomeOrUser)_timeline.json?user_id=\(newestTweet!.userID!)&since_id=\(newestTweet!.id!)")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            let newTweets = Tweet.parseJSONDataIntoTweets(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweets: newTweets)
                            })
                        case 400...499:
                            println("This is the client's fault, status code: \(httpResponse.statusCode)")
                            completionHandler(errorDescription: "This was your fault", tweets: nil)
                        case 500...599:
                            println("This is the server's fault, status code: \(httpResponse.statusCode)")
                            completionHandler(errorDescription: "This is the server's fault", tweets: nil)
                        default:
                            println("something bad happened")
                        }
                    }
                })
            }
        }

    }
    
    func fetchOlderTweets(stringforHomeOrUser: String, oldestTweet: Tweet?, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
            
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as? ACAccount
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/\(stringforHomeOrUser)_timeline.json?user_id=\(oldestTweet!.userID!)&max_id=\(oldestTweet!.id!)")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    if error == nil {
                        switch httpResponse.statusCode {
                        case 200...299:
                            let newTweets = Tweet.parseJSONDataIntoTweets(data)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(errorDescription: nil, tweets: newTweets)
                            })
                        case 400...499:
                            println("This is the client's fault, status code: \(httpResponse.statusCode)")
                            completionHandler(errorDescription: "This was your fault", tweets: nil)
                        case 500...599:
                             println("This is the server's fault, status code: \(httpResponse.statusCode)")
                            completionHandler(errorDescription: "This is the server's fault", tweets: nil)
                        default:
                            println("something bad happened")
                        }
                    }
                })
            }
        }
    }
    
    func downloadUserImageForTweet(tweet: Tweet, completionHandler: (image: UIImage) -> Void) {

        let url = NSURL(string: tweet.avatarImageURLString!)
        let imageData = NSData(contentsOfURL: url)  //Network call
        let avatarImage = UIImage(data: imageData)
        tweet.avatarImage = avatarImage
        
        NSOperationQueue.mainQueue().addOperationWithBlock ({ () -> Void in
            completionHandler(image: avatarImage)
        })
    }
}