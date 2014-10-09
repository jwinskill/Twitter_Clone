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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userTweet == nil {
            self.tableView.tableHeaderView = nil
        }
        self.userNameHeaderLabel.text = self.userTweet?.userName
        self.avatarHeaderImageView.image = self.userTweet?.avatarImage
        
           self.tableView.rowHeight = 100
           self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
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
                    //   self.tableView.rowHeight = 100
                    //   self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_DETAIL_VC") as TweetDetailViewController
        let selectedIndexPath = indexPath
        let selectedTweet = self.tweets?[selectedIndexPath.row]
        println(selectedTweet)
        vc.tweet = selectedTweet
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TwitterCell
        
        // This is where we would grab a reference to the correct tweet and use it to convigure the cell
        let tweet = self.tweets?[indexPath.row]
        if (tweet != nil) {
            cell.tweetTextLabel.text = tweet?.text
       //     cell.tweetTextLabel.sizeToFit()
       //     cell.tweetTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
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
}



        // Deprecated prepareForSegue method
        
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "SEGUE_TO_DETAIL" {
//            let vc = segue.destinationViewController as TweetDetailViewController
//            let selectedIndexPath = tableView.indexPathForSelectedRow()
//            let selectedTweet = self.tweets?[selectedIndexPath!.row]
//            vc.tweet = selectedTweet
//        }
//    }
