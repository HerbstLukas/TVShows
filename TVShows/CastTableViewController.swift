//
//  CastTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 08.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import SafariServices

class CastTableViewController: UITableViewController {
    
    var show = Show()
    var bckImage = UIImage()
    var actors = [CastMember]()
    var crew = [CrewMember]()
    var section = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, self.tableView.bounds.width, self.tableView.bounds.height)
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: bckImage)
        self.tableView.backgroundView!.addSubview(visualEffectView)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        title = "Cast"
        
        getCastForShow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCastForShow() {
        TraktManager.sharedManager.getPeopleInShow(showID: String(show.ids.trakt), extended: .FullAndImages) { (cast, crew, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            
            if cast.count > 0 {
                self.actors.removeAll()
                self.actors = cast
                self.section = self.section + 1
            } else {
                self.showErrorMessage()
            }
            
            if crew.count > 0 {
                self.crew.removeAll()
                self.crew = crew
                self.section = self.section + 1
            } else {
                //self.showErrorMessage()
            }

            self.reloadTableView()
        }
    }
    
    func showErrorMessage() {
        
        let alertController = UIAlertController(title: "Error", message: "Sorry, currently there are no cast information availible.", preferredStyle: .Alert)
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
        return section
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return self.actors.count }
        else if section == 1 { return self.crew.count }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("castCell", forIndexPath: indexPath) as! CastTableViewCell
        
        if indexPath.section == 0 {
            let actor = self.actors[indexPath.row]
            cell.configure(actor, crewMember: nil)
        } else if indexPath.section == 1 {
            let crewMember = self.crew[indexPath.row]
            cell.configure(nil, crewMember: crewMember)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Cast"
        } 
        if section == 1 {
            return "Crew"
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Create Actor for selected cell
        let actor = self.actors[indexPath.row]
        
        // Create ActionSheet
        let alertController = UIAlertController(title: nil, message: "Choose Website for more Information:", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        
        actor.person.idIMDB
        
        
        if actor.person.idIMDB.isEmpty {
        } else {
            let imdbAction = UIAlertAction(title: "IMDB.com", style: .Default) { (action) in
                self.showCastWebPage(actor.person.idIMDB, type: "IMDB")
            }
            alertController.addAction(imdbAction)
        }

        if String(actor.person.idTMDB).isEmpty {
        } else {
            let tmdbAction = UIAlertAction(title: "TMDB.com", style: .Default) { (action) in
                self.showCastWebPage(String(actor.person.idTMDB), type: "IMDB")
            }
            alertController.addAction(tmdbAction)
        }
        
        if String(actor.person.idTrakt).isEmpty {
        } else {
            let traktAction = UIAlertAction(title: "Trakt.tv", style: .Default) { (action) in
                self.showCastWebPage(String(actor.person.idTrakt), type: "Trakt")
            }
            alertController.addAction(traktAction)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true) { }
        }
    }
    
    func showCastWebPage(actorID: String, type: String) {
        
        var urlString = String()
        
        if type == "IMDB" {
            urlString = "http://www.imdb.com/name/\(actorID)"
        } else if type == "TMDB" {
            urlString = "https://www.themoviedb.org/person/\(actorID)"
        } else if type == "Trakt" {
            urlString = "https://trakt.tv/people/\(actorID)"
        }
        
        if let url = NSURL(string: urlString) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: false)
            presentViewController(vc, animated: true, completion: { () -> Void in
                vc.view.tintColor = UIColor.alizarinColor()
            })
        }
    }

    // MARK: - Navigation
    @IBAction func dissmissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
}
