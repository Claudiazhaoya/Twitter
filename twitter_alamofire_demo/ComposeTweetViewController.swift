//
//  ComposeTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Zhaoya Sun on 12/29/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeTweetViewController: UIViewController, ComposeViewControllerDelegate{
    func did(post: Tweet) {
    }

    @IBOutlet weak var composeTweetView: UITextView!
    var user: User?
    var delegate: ComposeViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTweetView.becomeFirstResponder()
        setNavigationBarButtons()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setNavigationBarButtons() {
        let closeImage = UIImage(named: "close-icon")
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeButtonTapped(sender:)))
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 64/255, green: 153/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItems = [closeButton]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetButtonTapped(sender:)))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func tweetButtonTapped(sender: UIBarButtonItem) {
        APIManager.shared.composeTweet(with: composeTweetView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
    }
    
    func closeButtonTapped(sender: UIBarButtonItem) {
        composeTweetView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}
