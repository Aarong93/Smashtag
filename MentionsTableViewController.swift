//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/2/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    var sectionLabels = [String]()
    
    private var mentions = [MentionType]()
    
    func pushHashtags(hashtagArray : [String]){mentions.append(MentionType.Hashtags(hashtagArray))}
    
    func pushURLs(URLsArray : [String]){mentions.append(MentionType.URLs(URLsArray))}
    
    func pushUsers(usersArray : [String]){mentions.append(MentionType.Users(usersArray))}
    
    func pushImages( imageArray : [NSURL]){mentions.append(MentionType.Images(imageArray))}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mentions[indexPath.section].simpleDescription() == UserMention || mentions[indexPath.section].simpleDescription() == Hashtag{
            if let text = mentions[indexPath.section].array()[indexPath.row] as? String{
                if let navController = self.navigationController{
                    if let tweetSearchViewController = navController.viewControllers[(navController.viewControllers.count-2)] as? TweetTableViewController{
                        tweetSearchViewController.searchText = text
                        navController.popViewControllerAnimated(true)
                    }
                }
            }
        }
        
        if mentions[indexPath.section].simpleDescription() == URL{
            if let url = NSURL(string: (mentions[indexPath.section].array()[indexPath.row] as String)){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if mentions[indexPath.section].simpleDescription() == Image{
            if let navController = self.navigationController{
                if let imageController = self.storyboard?.instantiateViewControllerWithIdentifier("ImagePresenter") as? ImageViewController{
                    imageController.imageURL = mentions[indexPath.section].array()[indexPath.row] as? NSURL
                    navController.pushViewController(imageController, animated: true)
                }
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sectionLabels[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return mentions[section].count()
    }
    
    private struct Storyboard{
        static let CellReuseIdentifier = "Mentions"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as MentionsTableViewCell
        mention.data = mentions[indexPath.section].array()[indexPath.row]
        return mention
    }
}
