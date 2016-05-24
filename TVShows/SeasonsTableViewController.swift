//
//  SeasonsTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class SeasonsTableViewController: UITableViewController {

    var showID = String()
    var showName = String()
    var bckImage = UIImage()
    var seasons = [Season]()
    var progressArr = [Progress]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeasonsForShow()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, self.tableView.bounds.width, self.tableView.bounds.height)
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: bckImage)
        self.tableView.backgroundView!.addSubview(visualEffectView)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("didReceiveMemoryWarning")
    }
    
    func getSeasonsForShow() {
        TraktManager.sharedManager.getSeasons(showID: showID, extended: .FullAndImages) { (objects, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let seasonsArr = objects  else { return }
            
            for season in seasonsArr {
                let seasonJson = JSON(season)
                let newSeason : Season = Season.init(fromJson: seasonJson)
                self.seasons.append(newSeason)
                    
                if self.seasons.count == seasonsArr.count {
                    if seasonsArr.count == 0 {
                        self.showErrorMessage()
                    } else {
                        self.getProgressForShow()
                    }
                }
            }
        }
    }
    
    func getProgressForShow() {
        TraktManager.sharedManager.getShowWatchedProgress(showID: showID, hidden: true, specials: true) { (dict , error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let pDict = dict else { return }
            
            let progressJson = JSON(pDict)
            let progress = Progress.init(fromJson: progressJson)
            self.progressArr.append(progress)
            
            self.reloadTableView()
        }
    }
    
    func showErrorMessage() {
        
        let alertController = UIAlertController(title: "Error", message: "Sorry, currently I have no information about seasons for this show. :(", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true) {
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("seasonCell", forIndexPath: indexPath) as! SeasonsTableViewCell

        let cellData = self.seasons[indexPath.row]
        let cellProgress = self.progressArr[0]
        
        cell.backgroundColor = UIColor.clearColor()
        cell.configure(cellData, showName: showName, progress: cellProgress)
        
        return cell
    }

    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toEpisodes" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedSeason = self.seasons[indexPath.row]
                let tmp = self.progressArr[0]
                var tmpThree = [PEpisode]()
                
                if indexPath.row < tmp.seasons.count {
                    let tmpTwo = tmp.seasons[indexPath.row]
                    tmpThree = tmpTwo.episodes
                } else {
                    
                }
                
                let vc = segue.destinationViewController as! EpisodesTableViewController
                vc.showID = showID
                vc.bckImage = bckImage
                vc.showName = showName
                vc.sNumber = selectedSeason.number
                vc.epProgress = tmpThree
            }
        }
    }
}
