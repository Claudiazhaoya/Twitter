//
//  ComposeTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Zhaoya Sun on 12/29/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController{
     var delegate: ComposeViewControllerDelegate?
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    @IBOutlet weak var composeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tweetButtonTapped(_ sender: Any) {
        APIManager.shared.composeTweet(with: composeTextView.text) { (tweet, error) in
            if let error = error {
               print(error.localizedDescription)
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
            }
        }
    }
}
protocol ComposeViewControllerDelegate {
    
    func did(post: Tweet)
}

