//
//  ShowInfoTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 08.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit

class ShowInfoTableViewController: UITableViewController {
    
    var show = Show()
    var bckImage = UIImage()
    
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showStatus: UILabel!
    @IBOutlet weak var raitingView: CosmosView!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var showYear: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var episodeRuntime: UILabel!
    @IBOutlet weak var showNetwork: UILabel!
    @IBOutlet weak var showOverview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 0, self.tableView.bounds.width, self.tableView.bounds.height)
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: bckImage)
        self.tableView.backgroundView!.addSubview(visualEffectView)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        title = "Information"
        setInformationToTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func setInformationToTableView() {
    
        dispatch_async(dispatch_get_main_queue()) {
            
            // Title:
            if self.show.title.isEmpty {
                self.showTitle.text = "Title unknown!"
            } else {
                self.showTitle.text = self.show.title
            }
            
            // Status:
            if self.show.status.isEmpty {
                self.showStatus.text = "Staus unknown!"
            } else {
                let status = self.show.status.stringByReplacingOccurrencesOfString("series", withString: "")
                self.showStatus.text = status.capitalizedString
            }
            
            // Genres:
            if let genresArr = self.show.genres {
                var allGenres = String()
                let onlyTwo = genresArr.takeElements(2)
                for genre in onlyTwo {
                    allGenres.addString(genre)
                }
                let tmpgenre = String(allGenres.characters.dropFirst())
                let genre = tmpgenre.capitalizedString
                
                if genre.isEmpty {
                    self.genres.text = "Genres unknown!"
                } else {
                    self.genres.text = String(genre.characters.dropFirst())
                }
            } else {
                self.genres.text = "Genres unknown!"
            }
            
            // Year:
            if String(self.show.year).isEmpty {
                self.showYear.text = "Year unknown!"
            } else {
                self.showYear.text = String(self.show.year)
            }
            
            // Homepage:
            if self.show.homepage.isEmpty {
                self.homepage.text = "Website unknown!"
            } else {
                self.homepage.text = self.show.homepage
            }
            
            // Episode Runtime:
            if String(self.show.runtime).isEmpty {
                self.episodeRuntime.text = "Runtime unknown!"
            } else {
                self.episodeRuntime.text = "\(self.show.runtime) min"
            }
            
            // Network:
            if self.show.network.isEmpty {
                self.showNetwork.text = "Network unknown!"
            } else {
                self.showNetwork.text = self.show.network
            }
            
            // Overview:
            if self.show.overview.isEmpty {
                self.showOverview.text = "Sorry no overview to show :("
            } else {
                self.showOverview.text = self.show.overview
            }
            
            // Raiting:
            if let tmpRating = self.show.rating {
                if String(tmpRating).isEmpty {
                    self.raitingView.rating = 0
                } else {
                    let rating = tmpRating / 2
                    self.raitingView.settings.fillMode = StarFillMode.Half
                    self.raitingView.settings.colorFilled = UIColor.orangeColor()
                    self.raitingView.settings.updateOnTouch = false
                    self.raitingView.borderColorEmpty = UIColor.orangeColor()
                    self.raitingView.rating = Double(rating)
                }
            } else {
                self.raitingView.rating = 0
            }
        }
    }

    // MARK: - Navigation
    @IBAction func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
