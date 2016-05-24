//
//  SearchTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 30.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    lazy var searchBar = UISearchBar()
    var searchResults = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.hidden = true
        searchBar.placeholder = "Search for show"
        searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchResults.removeAll(keepCapacity: false)
        
        guard let searchTextTMP = self.searchBar.text else { return }
        
        let searchText = searchTextTMP.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if ((searchText?.isEmpty) != nil) {
            var types = [SearchType]()
            types.append(SearchType.Show)
            TraktManager.sharedManager.search(searchText!, types: types) { (objects, error) -> Void in
                
                // Handle error
                guard error == nil else { return }
                guard let resultsArr = objects else { return }
                
                for result in resultsArr {
                    let resultJson = JSON(result)
                    let newShow = Show.init(fromJson: resultJson["show"])
                    self.searchResults.append(newShow)
                }
                
                if self.searchResults.count == resultsArr.count {
                    if resultsArr.count == 0 {
                        self.showErrorMessage()
                    } else {
                        self.reloadTableView()
                    }
                }
            }
        } else {
            
        }
    }

    func showErrorMessage() {
        
        let alertController = UIAlertController(title: "Error", message: "Sorry, I found nothing for your search query. :(", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }

    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.hidden = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchResults.removeAll(keepCapacity: false)
        dispatch_async(dispatch_get_main_queue()) {
            self.searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
            self.tableView.hidden = true
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        let show = searchResults[indexPath.row]
        cell.configure(show)

        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowDetail" {
            
            let vc = segue.destinationViewController as! ShowDetailViewController
            vc.hidesBottomBarWhenPushed = true
            
            let indexPath = self.tableView.indexPathForSelectedRow
                
            let showCellData = self.searchResults[indexPath!.row]
            vc.showID = String(showCellData.ids.trakt)
            vc.showTitle = showCellData.title
            vc.posterURL = showCellData.images.poster.full
        }
    }
}
