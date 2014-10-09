//
//  TwitterCell.swift
//  TwitterClone
//
//  Created by Joshua Winskill on 10/7/14.
//  Copyright (c) 2014 Joshua Winskill. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
