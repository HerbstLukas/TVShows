//
//  WatchlistTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 28.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class WatchlistTableViewController: UITableViewController {
    
    var lists = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List's"
        getCustomLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func getCustomLists() {
        
        TraktManager.sharedManager.getCustomLists { (objects, error) -> Void in
    
            guard error == nil else { return }
            
            guard let listArr = objects else { return }
            
            for list in listArr {
                let listJson = JSON(list)
                let newList = List.init(fromJson: listJson)
                self.lists.append(newList)
                
                if self.lists.count == listArr.count {
                    self.reloadTableView()
                }
            }
        }
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rtValue = Int()
        
        switch (section) {
        case 0:
            rtValue = 1
        case 1:
            rtValue = self.lists.count
        default: break
        }
        
        return rtValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("allShowsCell", forIndexPath: indexPath)
            cell.textLabel!.text = "All watched shows"
            
            return cell
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! WatchlistTableViewCell
            let cellData = lists[indexPath.row]
            (cell as! WatchlistTableViewCell).configure(cellData)
            return cell
        default: break
            
        }
        
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCustomList" {
            
            let vc = segue.destinationViewController as! CustomListTableViewController
            vc.hidesBottomBarWhenPushed = true
            
            print("here")
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let list = self.lists[indexPath!.row]
            
            if (indexPath?.section == 0)  {
                vc.isAllShows = true
            } else if (indexPath?.section == 1) {
                vc.isAllShows = false
                vc.list = list
            }
        }
    }
}
