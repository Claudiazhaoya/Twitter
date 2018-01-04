//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
        var tweets: [Tweet] = []
        var refreshControl: UIRefreshControl!
        var tweetMaxId: Int?
        private var isMoreTweetsLoading = false
        var userForSegue: User?
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
            APIManager.shared.logout()
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 40
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(fetchTweets(forInfiniteScroll:)), for: .valueChanged)
            refreshControl.backgroundColor = UIColor.groupTableViewBackground
            tableView.addSubview(refreshControl)
        
            setNavigationBarButtons()
          
            
            let insets = tableView.contentInset;
            tableView.contentInset = insets
            
            fetchTweets(forInfiniteScroll: false)
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if !isMoreTweetsLoading {
                let ScrollViewContentHeight = self.tableView.contentSize.height
                let scrollOffsetThreshold = ScrollViewContentHeight - self.tableView.bounds.size.height
                
                if scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging && !tweets.isEmpty {
                    isMoreTweetsLoading = true
        
                    
                    self.fetchTweets(forInfiniteScroll: true)
                }
            }
        }
        
        func fetchTweets(forInfiniteScroll: Bool) {
            APIManager.shared.getHomeTimeLine { (tweets, error) in
                if let tweets = tweets {
                    self.tweets = tweets
                    self.tableView.reloadData()
                } else if let error = error {
                    print("Error getting home timeline: " + error.localizedDescription)
                }
                self.refreshControl.endRefreshing()
            }
          
        }
        
        func setNavigationBarButtons() {
            let composeImage = UIImage(named: "edit-icon")
            let composeButton = UIBarButtonItem(image: composeImage, style: .plain, target: self, action: #selector(composeButtonTapped(sender:)))
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white

            self.navigationController?.navigationBar.isTranslucent = false

            self.navigationItem.leftBarButtonItem = composeButton
        }
        
        func composeButtonTapped(sender: UIBarButtonItem) {
            performSegue(withIdentifier: "ComposeTweetSegue", sender: self)
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
            let tweet = tweets[indexPath.row]
            if let url = tweet.profileUrl {
                cell.profilePictureImageView.setImageWith(url)
            }
            cell.usernameLabel.text = tweet.user?.name
            cell.userHandleLabel.text = "@\((tweet.user?.screenname)!)"
            cell.tweetTextLabel.text = tweet.text
            cell.favoriteCount.text = "\(tweet.favoriteCount)"
            cell.retweetCount.text = "\(tweet.retweetCount)"
            cell.tweet = tweet
            
            return cell
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
}
extension TimelineViewController: ComposeViewControllerDelegate {
    func did(post: Tweet) {
        dismiss(animated: true, completion: nil)
    }
}
    

