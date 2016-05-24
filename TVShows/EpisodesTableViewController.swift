//
//  EpisodesTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 15.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import Nuke

class EpisodesTableViewController: UITableViewController {
    
    var showID = String()
    var showName = String()
    var sNumber = Int()
    var bckImage = UIImage()
    var epProgress = [PEpisode]()
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode's"
        loadEpisodesForSeason()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, self.tableView.bounds.width, self.tableView.bounds.height)
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: bckImage)
        self.tableView.backgroundView!.addSubview(visualEffectView)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("didReceiveMemoryWarning")
    }
    
    
    func loadEpisodesForSeason() {
        TraktManager.sharedManager.getEpisodesForSeason(showID: showID, season: sNumber, extended: .Full) { (objects, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let episodesArr = objects else { return }
            
            for episode in episodesArr {
                let episodeJson = JSON(episode)
                let newEpisode : Episode = Episode.init(fromJson: episodeJson)
                self.episodes.append(newEpisode)
                    
                if self.episodes.count == episodesArr.count {
                    if episodesArr.count == 0 {
                        self.showErrorMessage()
                    } else {
                        self.reloadTableView()
                    }
                }
            }
        }
    }

    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func showErrorMessage() {
        
        let alertController = UIAlertController(title: "Error", message: "Sorry, currently I have no information about episodes for this season. :(", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true) {
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("episodeCell", forIndexPath: indexPath) as! EpisodeTableViewCell
        cell.backgroundColor = UIColor.clearColor()

        let cellData = self.episodes[indexPath.row]
        
        if epProgress.count == 0 {
            cell.configure(cellData, progress: nil)
        } else {
            if epProgress.count > indexPath.row {
                let prgrss = epProgress[indexPath.row]
                cell.configure(cellData, progress: prgrss)
            }
        }
        
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEpisodeDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedEpisode = self.episodes[indexPath.row]
                let cell = sender as! EpisodeTableViewCell
                
                let vc = segue.destinationViewController as! EpisodeDetailTableViewController
                vc.showID = showID
                vc.bckImage = bckImage
                vc.showName = showName
                vc.eNumber = selectedEpisode.number
                vc.sNumber = sNumber
                vc.isWatched = cell.isWatched
                vc.epToCheck = cell.epToCheck
            }
        }
    }


}
