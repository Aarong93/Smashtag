//
//  SearchHistoryViewController.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/8/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    private struct Key{
        static let searchesDone = "searchesDone"
        static let defaults = NSUserDefaults.standardUserDefaults()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tabBarController!.delegate = self
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        if let nav = viewController as? UINavigationController{
//            if let shtvc = nav.viewControllers[0] as? SearchHistoryTableViewController{
//                shtvc.tableView.reloadData()
//            }
//        }
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let navController = self.navigationController{
            if let tweetSearchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchTwitter") as? TweetTableViewController{
                var searchHistory = Key.defaults.objectForKey(Key.searchesDone) as? [String] ?? [String]()
                tweetSearchViewController.searchText = searchHistory.reverse()[indexPath.row]
                navController.pushViewController(tweetSearchViewController, animated: true)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var searchHistory = Key.defaults.objectForKey(Key.searchesDone) as? [String] ?? [String]()
        return searchHistory.count
    }
    
    private struct Storyboard{
        static let CellReuseIdentifier = "History"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var searchHistory = Key.defaults.objectForKey(Key.searchesDone) as? [String] ?? [String]()
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as SearchHistoryTableViewCell
        cell.data = searchHistory.reverse()[indexPath.row]
        return cell
    }
    
}
