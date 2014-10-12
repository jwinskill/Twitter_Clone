//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Joshua Winskill on 10/6/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    var twitterAccount: ACAccount?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameHeaderLabel: UILabel!
    @IBOutlet weak var avatarHeaderImageView: UIImageView!
    var networkController: NetworkController!
    var userTweet: Tweet?
    var home = true
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Implement a header only if visiting another user's timeline
        if userTweet == nil {
            self.tableView.tableHeaderView = nil
        }
        self.userNameHeaderLabel.text = self.userTweet?.userName
        self.avatarHeaderImageView.image = self.userTweet?.avatarImage
        self.avatarHeaderImageView.layer.cornerRadius = self.avatarHeaderImageView.frame.height * 0.1
        self.avatarHeaderImageView.layer.masksToBounds = true
        
        // Add a custom Tweetcell from a nib
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        // Implement the networkController as a singleton
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        if userTweet == nil {
            self.networkController.fetchHomeTimeline(nil, completionHandler: { (errorDescription, tweets) -> Void in
                
                if errorDescription != nil {
                    //alert the user that something went wrong
                    println("something went wrong")
                } else {
                    self.tweets = tweets
                    self.tableView.reloadData()
                }
            })
        } else {
            self.networkController.fetchHomeTimeline(userTweet, completionHandler: { (errorDescription, tweets) -> Void in
                
                if errorDescription != nil {
                    //alert the user that something went wrong
                    println("something went wrong")
                } else {
                    self.tweets = tweets
                    self.tableView.reloadData()
                }
            })
        }
        
        // Add a UIRefreshControl to tableView for new tweets
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.blueColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "refreshTweets:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TwitterCell
        
        // This is where we would grab a reference to the correct tweet and use it to convigure the cell
        let tweet = self.tweets?[indexPath.row]
        if (tweet != nil) {
            cell.tweetTextLabel.text = tweet?.text
            cell.tweetTextLabel.preferredMaxLayoutWidth = cell.frame.size.width - 124
            if tweet?.avatarImage? != nil {
                cell.avatarImageView?.image = tweet?.avatarImage!
            } else {
                
                self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> Void in
                    let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TwitterCell?
                    cellForImage?.avatarImageView?.image = image
                })
            }
        }
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    // Prepare to push to tweet detail view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_DETAIL_VC") as TweetDetailViewController
        let selectedIndexPath = indexPath
        let selectedTweet = self.tweets?[selectedIndexPath.row]
        vc.tweet = selectedTweet
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

        

    // Method for infinite scroll
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.home == true {
            if indexPath.row == self.tweets!.count - 1 {
                // add more cells to the tableView
                self.networkController.fetchOlderTweets("home", oldestTweet: tweets!.last, completionHandler: { (errorDescription, tweets) -> Void in
                    if errorDescription != nil {
                        // let the user know something went wrong
                        println("something bad happened")
                    } else {
                        self.tweets = self.tweets! + tweets!
                        self.tableView.reloadData()
                    }
                })
            }
        } else {
            if indexPath.row == self.tweets!.count - 1 {
                // add more cells to the tableView
                self.networkController.fetchOlderTweets("user", oldestTweet: tweets!.last, completionHandler: { (errorDescription, tweets) -> Void in
                    if errorDescription != nil {
                        // let the user know something went wrong
                        println("tweets could not be added")
                    } else {
                        self.tweets = self.tweets! + tweets!
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }

    // Method for pull-down refresh for tweets
    func refreshTweets(sender: AnyObject) {
        
        if self.home == true {
            self.networkController.fetchRefreshedTweets("home", newestTweet: tweets?[0], completionHandler: { (errorDescription, tweets) -> Void in
                if errorDescription != nil {
                    println("tweets were not refreshed properly")
                } else {
                    self.tweets = tweets! + self.tweets!
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
            })
        } else {
            self.networkController.fetchRefreshedTweets("user", newestTweet: tweets?[0], completionHandler: { (errorDescription, tweets) -> Void in
                if errorDescription != nil {
                    println("tweets were not refreshed properly")
                } else {
                    self.tweets = tweets! + self.tweets!
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
            })
        }
    }
    
}
