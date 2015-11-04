//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Aaron Grau on 10/28/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweets = [[Tweet]]()
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    var lastSuccesfulRequest: TwitterRequest?
    
    // MARK: Load Tweets
    
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccesfulRequest == nil{
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            }
            else{
                return nil
            }
        }
        else{
            return lastSuccesfulRequest!.requestForNewer
        }
    }
    
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil{
            if let request = nextRequestToAttempt{
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()){ () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccesfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        sender?.endRefreshing()
                    }
                }
            }
        }
        else{
        sender?.endRefreshing()
        }
    }

    var searchText: String? = "#vandy"{
        didSet{
            lastSuccesfulRequest = nil
            searchTextField.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    func refresh(){
        if refreshControl != nil{
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    // MARK: Tableview Cell Set Up
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets[section].count
    }
    
    private struct Storyboard{
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell
        
        cell.tweet = tweets[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }

    // MARK: Prepare for Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mentionsController = segue.destinationViewController as? MentionsTableViewController{
            let path = self.tableView.indexPathForSelectedRow()
            let tweet = tweets[path!.section][path!.row]
            var images = [NSURL]()
            for image in tweet.media{images.append(image.url)}
            if !images.isEmpty{
                mentionsController.pushImages(images)
                mentionsController.sectionLabels.append("Images")
            }
            var hashtagsInText = [String]()
            for hashtag in tweet.hashtags{hashtagsInText.append(hashtag.keyword)}
            if !hashtagsInText.isEmpty{
                mentionsController.pushHashtags(hashtagsInText)
                mentionsController.sectionLabels.append("Hashtags")
            }
            var urlsInText = [String]()
            for url in tweet.urls{urlsInText.append(url.keyword)}
            if !urlsInText.isEmpty{
                mentionsController.pushURLs(urlsInText)
                mentionsController.sectionLabels.append("Links")
            }
            var usersInText = [String]()
            for user in tweet.userMentions{usersInText.append(user.keyword)}
            if !usersInText.isEmpty{
                mentionsController.pushUsers(usersInText)
                mentionsController.sectionLabels.append("Users Mentioned")
            }
        }
    }
}
