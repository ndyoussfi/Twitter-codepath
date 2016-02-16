//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Noureddine Youssfi on 2/12/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//


import UIKit
import GIFRefreshControl


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    var refreshControl = GIFRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var loadMoreOffset = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        // Do any additional setup after loading the view.
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }
        
        
        let URL = NSBundle.mainBundle().URLForResource("giphy", withExtension: "gif")
        let data = NSData(contentsOfURL: URL!)
        
        self.refreshControl = GIFRefreshControl()
        refreshControl.animatedImage = GIFAnimatedImage(data: data!)
        refreshControl.contentMode = .ScaleAspectFill
        refreshControl.addTarget(self, action: "refreshAction", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        setupInfiniteScrollView()
        
        tableView.infiniteScrollIndicatorStyle = .Gray
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            tableView.reloadData()
            
        }
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser!.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func refreshAction(){
            self.tableView.reloadData()
            print("hi")
            self.refreshControl.endRefreshing()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        

        if (tweets != nil) {
            cell.tweet = tweets![indexPath.row]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onRetweet(sender: AnyObject) {
        
        var subview: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subview)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as! TweetCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {

                self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int + 1

                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
            }
        
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        var button : UIButton = sender as! UIButton
        var subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        let cell =  self.tableView.cellForRowAtIndexPath(indexPath)! as! TweetCell
        let tweet = tweets![indexPath.row]
        let tweetID = tweet.id
        
        
        TwitterClient.sharedInstance.favoriteWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
               
                self.tweets![indexPath.row].favCount = self.tweets![indexPath.row].favCount as! Int + 1
                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
            }
        }
    }
   
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = true
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.tweets!.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
            
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                loadMoreData()
            }
        }
    }
    }
