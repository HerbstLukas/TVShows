//
//  ShowDetailViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import Nuke
import TraktKit
import AVKit
import AVFoundation

class ShowDetailViewController: UIViewController {
    
    var showID = String()
    var showTitle = String()
    var posterURL = String()
    var progressArr = [Progress]()
    var show = Show()
    var trailerURL = NSURL()
    var stringURL = String()
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bckImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var trailerButton: UIBarButtonItem!
    @IBOutlet weak var addRemoveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = showTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Information"), style: .Done, target: self, action: "showInformation")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.trailerButton.enabled = false
        }
        
        loadImage()
        getProgressForShow()
        getFullShowInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func getProgressForShow() {
        TraktManager.sharedManager.getShowWatchedProgress(showID: showID, hidden: true, specials: true) { (dict , error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let pDict = dict else { return }
            
            let progressJson = JSON(pDict)
            let progress = Progress.init(fromJson: progressJson)
            self.progressArr.append(progress)
        }
    }
    
    func getFullShowInformation() {
        TraktManager.sharedManager.getShowSummary(showID: showID, extended: .FullAndImages) { (dictionary, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let showInformation = dictionary else { return }
            
            // Create Show
            let showJson = JSON(showInformation)
            self.show = Show.init(fromJson: showJson)
            self.checkForTrailer()
        }
    }
    
    func checkForTrailer() {
        
        guard let stringURL = show.trailer else { return }
        
        if stringURL.isEmpty {
            dispatch_async(dispatch_get_main_queue()) {
                self.trailerButton.enabled = false
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.trailerButton.enabled = true
            }
            
            let urlComponents = stringURL.componentsSeparatedByString("=")
            let youtubeID = urlComponents[1]
            
            YoutubeParser.h264Streams(youtubeID) { (streams, error) -> Void in
                if let s = streams, v = YoutubeParser.getBestQuality(s) {
                    if let streamURL = v.url {
                        self.trailerURL = streamURL
                    } else {
                        // Error Handling
                    }
                }
            }
        }
    }
    
    func loadImage() {
        loadingIndicator.color = UIColor.alizarinColor()
        loadingIndicator.startAnimating()
        
        let req = NSURLRequest(URL: NSURL(string: posterURL)!)
        let request = ImageRequest(URLRequest: req)
        
        Nuke.taskWithRequest(request) { response in
            switch response {
            case let .Success(image, _):
                self.posterImageView.image = image
                self.bckImageView.image = image
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
            case let .Failure(error):
                print(error)
            }
        }.resume()
    }
    
    @IBAction func share(sender: AnyObject) {
        
        let shareText = "Check out \(showTitle). Series I just found via TVShows App."
        
        if let image = self.posterImageView.image {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func addRemoveFromWatchlist(sender: AnyObject) {
    
    }
    
    func getBackground() -> UIImage {
        
        if (posterImageView.image == nil) {
            let window: UIWindow! = UIApplication.sharedApplication().keyWindow
            let windowImage = window.capture()
            return windowImage
        } else {
            return posterImageView.image!
        }
    }

    // MARK: - Navigation
    
    func showInformation() {
        performSegueWithIdentifier("toShowInfo", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toSeasons" {
            let image = getBackground()
            
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.topViewController as! SeasonsTableViewController
            vc.showName = showTitle
            vc.showID = showID
            vc.bckImage = image
            vc.progressArr = progressArr
        } else if segue.identifier == "showTrailer" {
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVPlayer(URL: self.trailerURL)
            destination.player?.play()
        } else if segue.identifier == "toShowInfo" {
            let image = getBackground()
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.topViewController as! ShowInfoTableViewController
            vc.show = self.show
            vc.bckImage = image
        } else if segue.identifier == "toCastVC" {
            let image = getBackground()
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.topViewController as! CastTableViewController
            vc.show = self.show
            vc.bckImage = image
        }
    }
}
