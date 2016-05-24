//
//  EpisodeDetailTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 17.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import Nuke

class EpisodeDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var eScreenshot: UIImageView!
    @IBOutlet weak var eTitle: UILabel!
    @IBOutlet weak var eAired: UILabel!
    @IBOutlet weak var eVotes: UILabel!
    @IBOutlet weak var eOverview: UITextView!
    @IBOutlet weak var eStars: CosmosView!
    
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    
    var isWatched = Bool()
    var epToCheck = Episode()
    
    var showID = String()
    var showName = String()
    var sNumber = Int()
    var eNumber = Int()
    var bckImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEpisodeDetailInfo()
        configureButton()
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
        
        watchButton.tintColor = UIColor.alizarinColor()
        watchButton.setTitleColor(UIColor.alizarinColor(), forState: .Normal)
        checkInButton.setTitleColor(UIColor.alizarinColor(), forState: .Normal)
        checkInButton.tintColor = UIColor.alizarinColor()
        
        checkInButton.layer.cornerRadius = 10
        checkInButton.layer.borderWidth = 1
        checkInButton.layer.borderColor = UIColor.alizarinColor().CGColor
        
        watchButton.layer.cornerRadius = 10
        watchButton.layer.borderWidth = 1
        watchButton.layer.borderColor = UIColor.alizarinColor().CGColor
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func loadEpisodeDetailInfo() {
        
        TraktManager.sharedManager.getEpisodeSummary(showID: showID, seasonNumber: sNumber, episodeNumber: eNumber, extended: .FullAndImages) { (episodeResponce, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let episodeDict = episodeResponce else { return }
            
            // Make Episode
            let episodeJson = JSON(episodeDict)
            let episode = Episode.init(fromJson: episodeJson)
            
            // Finisch
            self.loadImage(episode)
            self.setEpisodeInformation(episode)
        }
    }
    
    func loadImage(episode : Episode) {
        
        if episode.images.screenshot.full.isEmpty {
            print(episode.images.screenshot.full)
        }
        
//        if episode.images.screenshot.full.isEmpty { } else {
//            let req = NSURLRequest(URL: NSURL(string: episode.images.screenshot.full)!)
//        
//            var request = ImageRequest(URLRequest: req)
//            request.contentMode = .AspectFill
//        
//            Nuke.taskWithRequest(request) { response in
//                switch response {
//                case let .Success(image, _):
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.eScreenshot.image = image
//                    }
//                case let .Failure(error):
//                    // Handle Error!
//                    print(error)
//                }
//            }.resume()
//        }
    }
    
    func setEpisodeInformation(episode: Episode) {
        dispatch_async(dispatch_get_main_queue()) {
                        
            if let date = episode.firstAired {
                if date.isEmpty {
                    self.eAired.text = "No date known."
                } else {
                    let dateFromString = date.toDateFromString()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale.currentLocale()
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    self.eAired.text = dateFormatter.stringFromDate(dateFromString)
                }
            } else {
                self.eAired.text = "No date known."
            }
            
            if episode.title.isEmpty {
                self.eTitle.text = "Title unknown!"
            } else {
                self.eTitle.text = episode.title
            }
            
            self.eOverview.tintColor = UIColor.whiteColor()
            
            if let overview = episode.overview {
                self.eOverview.text = overview
            } else {
                self.eOverview.text = "Sorry no overview to show :("
            }
            
            if String(episode.votes).isEmpty {
                self.eVotes.text = "0"
            } else {
                self.eVotes.text = String(episode.votes)
            }
            
            if String(episode.rating).isEmpty {
                                self.eStars.rating = 0
            } else {
                let rating = episode.rating / 2
                self.eStars.settings.fillMode = StarFillMode.Half
                self.eStars.settings.colorFilled = UIColor.orangeColor()
                self.eStars.settings.updateOnTouch = false
                self.eStars.borderColorEmpty = UIColor.orangeColor()
                self.eStars.rating = Double(rating)
            }
        }
    }
    
    func configureButton() {
        
        if isWatched == true {
            updateButton(true)
        } else if isWatched == false {
            updateButton(false)
        }
    }
    
    func updateButton(status: Bool) {
        if status == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.watchButton.setTitle("MARK AS UNSEEN", forState: .Normal)
            }
            self.isWatched = true
        } else if status == false {
            dispatch_async(dispatch_get_main_queue()) {
                self.watchButton.setTitle("MARK AS SEEN", forState: .Normal)
            }
            self.isWatched = false
        }
    }
    
    func showNotification(status: Bool, text: String) {
        
        var type : GSMessageType = .Success
        
        if status == false {
            type = .Error
        } else if status == true {
            type = .Success
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController?.view.showMessage(text, type: type, options: [.Animation(.Slide),
                .AnimationDuration(0.3),
                .AutoHide(true),
                .AutoHideDelay(3.0),
                .Height(44.0),
                .HideOnTap(true),
                .Position(.Top),
                .TextColor(.whiteColor())])
        }
    }
    
    @IBAction func markAsWatchedOrUnwatched(sender: AnyObject) {
        let nilArr = [RawJSON]()
        var arr = [RawJSON]()
        
        let jsonForEpisode = epToCheck.createJsonDictionary()
        arr.append(jsonForEpisode)
        
        if isWatched == false {
            TraktManager.sharedManager.addToHistory(movies: nilArr, shows: nilArr, episodes: arr, completion: { (success) -> Void in
                
                if success == true {
                    self.updateButton(true)
                    self.showNotification(true, text: "Yep, episode marked as watched! :)")
                } else if success == false {
                    self.showNotification(false, text: "Sorry, there was an error! :(")
                }
            })
        } else if isWatched == true {
            TraktManager.sharedManager.removeFromHistory(movies: nilArr, shows: nilArr, episodes: arr, completion: { (success) -> Void in
                
                if success == true {
                    self.updateButton(false)
                    self.showNotification(true, text: "Yep, episode unmarked! :)")
                } else if success == false {
                    self.showNotification(false, text: "Sorry, there was an error! :(")
                }
            })
        }
    }
    
    @IBAction func checkIntoThisEpisode(sender: AnyObject) {
        
        checkForWatching()
    }
    
    func checkForWatching() {
        
        TraktManager.sharedManager.getWatching { (watching, dictionary, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let dic = dictionary else { return }
            
            if watching == true {
                let watchingJson = JSON(dic)
                let episodeWatching = Watching.init(fromJson: watchingJson)
                self.showOptionToCancel(episodeWatching)
            } else if watching == false {
                self.checkIntoEpisode()
            }
        }
    }
    
    func checkIntoEpisode() {
    
        let jsonForEpisode = epToCheck.createJsonDictionary()
        
        TraktManager.sharedManager.checkIn(movie: nil, episode: jsonForEpisode) { (success) -> Void in
            
            if success == true {
                self.showNotification(true, text: "Got it, you are watching this now. :)")
            } else if success == false {
                self.showNotification(false, text: "Sorry, there was an error! :(")
            }
        }
    }
    
    func showOptionToCancel(watching : Watching) {
        let alertController = UIAlertController(title: "Already watching an episode!",
            message: "Currently you are watching \(watching.episode.title) from \(watching.show.title). You have to wait until this episode is finished \(watching.expiresAt), or you can delet this check in and start a new one? ",
            preferredStyle: .ActionSheet)
        
        let imdbAction = UIAlertAction(title: "Check in", style: .Destructive) { (action) in
            TraktManager.sharedManager.deleteActiveCheckins({ (success) -> Void in
                if success == true {
                    self.checkIntoEpisode()
                } else if success == false {
                    self.showNotification(false, text: "Sorry, there was an error deleting the check in! :(")
                }
            })
        }
        alertController.addAction(imdbAction)
        
        let cancelAction = UIAlertAction(title: "Ok, waiting.", style: .Default) { (action) in
        }
        alertController.addAction(cancelAction)
    
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
