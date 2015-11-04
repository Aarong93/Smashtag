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
    
    struct Storyboard{
        static let CellReuseIdentifier = "Mentions"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as MentionsTableViewCell
        mention.data = mentions[indexPath.section].array()[indexPath.row]
        return mention
    }
}
