//
//  DeckTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 17.03.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class DeckTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "On Deck"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("onDeckCell", forIndexPath: indexPath)

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - Trakt Shizzle

}