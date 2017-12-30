//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AFNetworking

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ProfileViewSegueDelegate {
    
    func profileImageTapped(user: User) {
    }
    
    
        var tweets: [Tweet] = []
        var refreshControl: UIRefreshControl!
        var tweetMaxId: Int?
        private var isMoreTweetsLoading = false
        var userForSegue: User?
        
    @IBOutlet weak var tableView: UITableView!
    
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
            
            self.tabBarController?.tabBar.tintColor = UIColor(colorLiteralRed: 64/255, green: 153/255, blue: 255/255, alpha: 1)
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
            APIManager.shared.getHomeTimeLine { (tweets:[Tweet]!, error: Error?) in
                self.isMoreTweetsLoading = false
                self.tweets = forInfiniteScroll ? self.tweets + tweets : tweets
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
          
        }
        
        func setNavigationBarButtons() {
            let composeImage = UIImage(named: "edit-icon")
            
           // let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
           // logoView.image = logoImage
           // logoView.contentMode = .scaleAspectFit
           // let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
           // logoView.frame = titleView.bounds
           // titleView.addSubview(logoView)
            
           // let connectButton = UIBarButtonItem(image: connectImage, style: .plain, target: self, action: nil)
            let composeButton = UIBarButtonItem(image: composeImage, style: .plain, target: self, action: #selector(composeButtonTapped(sender:)))
           // let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
           // searchButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -44)
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 64/255, green: 153/255, blue: 255/255, alpha: 1)
            self.navigationController?.navigationBar.isTranslucent = false
          //  self.navigationItem.rightBarButtonItems = [composeButton]
           // self.navigationItem.titleView = titleView
            self.navigationItem.leftBarButtonItem = composeButton
        }
        
        func composeButtonTapped(sender: UIBarButtonItem) {
            performSegue(withIdentifier: "ComposeTweetSegue", sender: self)
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count
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
            cell.delegate = self
            
            return cell
        }
    
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
    }
    

