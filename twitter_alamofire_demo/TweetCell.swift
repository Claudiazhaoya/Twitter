//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Lottie

protocol ProfileViewSegueDelegate {
    func profileImageTapped(user: User)
}
class TweetCell: UITableViewCell {
    var delegate: ProfileViewSegueDelegate?
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    profilePictureImageView.layer.cornerRadius = 5
        profilePictureImageView.clipsToBounds = true
        retweetCount.text = "\(String(describing: tweet?.retweetCount))"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePictureImageView?.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.profileImageTapped(user: (tweet?.user)!)
        
    }
    
    @IBAction func onHeartTap(_ sender: Any) {
        favoriteCount.text = "\(Int(favoriteCount.text!)! + 1)"
        favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
    }
    
    @IBAction func onRetweetTap(_ sender: Any) {
        retweetCount.text = "\(Int(retweetCount.text!)! + 1)"
        retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
