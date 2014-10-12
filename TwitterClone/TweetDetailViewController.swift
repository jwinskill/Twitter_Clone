//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Joshua Winskill on 10/8/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var networkController : NetworkController!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet?

    @IBAction func didPressAvatarButton(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HOME_TIMELINE_VC") as HomeTimeLineViewController
        vc.userTweet = self.tweet!
        vc.home = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewFields() {
        self.userNameLabel.text = tweet?.userName
        self.userImageView.image = tweet?.avatarImage
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height * 0.1
        self.userImageView.layer.masksToBounds = true
        self.tweetMessageLabel.text = tweet?.text
        self.retweetCountLabel.text = tweet?.retweets?.description
        self.favoritesCountLabel.text = tweet?.favorites?.description
    }
    
}
