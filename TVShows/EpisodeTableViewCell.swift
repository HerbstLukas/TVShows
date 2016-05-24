//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 16.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeNr: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var addRemoveHistory: UIButton!
    @IBOutlet weak var lastWatched: UILabel!
    
    var isWatched = Bool()
    var epToCheck = Episode()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func addRemove(sender: AnyObject) {
        
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
    
    func configure(episode: Episode, progress: PEpisode?) {
        
        var seasonNr = String()
        var episodeNmbr = String()
        
        epToCheck = episode
        
        dispatch_async(dispatch_get_main_queue()) {
            if episode.season > 9 {
                seasonNr = "\(episode.season)"
            } else {
                seasonNr = "0\(episode.season)"
            }
        
            if episode.number > 9 {
                episodeNmbr = "\(episode.number)"
            } else {
                episodeNmbr = "0\(episode.number)"
            }
        
            if let date = episode.firstAired {
                if date.isEmpty {
                    self.lastWatched.text = "Not aired yet."
                } else {
                    let dateFromString = date.toDateFromString()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale.currentLocale()
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    self.lastWatched.text = dateFormatter.stringFromDate(dateFromString)
                }
            } else {
                self.lastWatched.text = "Not aired yet."
            }
        
            if episode.title.isEmpty {
                self.episodeName.text = "No name known yet."
            } else {
                self.episodeName.text = episode.title
            }
        
            let epNrString = "\(seasonNr)\(episodeNmbr)"
        
            if epNrString.isEmpty {
                self.episodeNr.text = "0x0"
            } else {
                self.episodeNr.text = "\(seasonNr)x\(episodeNmbr)"
            }
        
            if progress == nil {
                self.addRemoveHistory.hidden = true
            } else {
                if let watched = progress?.completed {
                    self.updateButton(watched)
                }
            }
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
            self.superview?.superview?.showMessage(text, type: type, options: [.Animation(.Slide),
                                                              .AnimationDuration(0.3),
                                                              .AutoHide(true),
                                                              .AutoHideDelay(3.0),
                                                              .Height(44.0),
                                                              .HideOnTap(true),
                                                              .Position(.Top),
                                                              .TextColor(.whiteColor())])
        }
    }
    
    func updateButton(status: Bool) {
        if status == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.addRemoveHistory.setImage(UIImage(named: "Checkmark"), forState: .Normal)
            }
            self.isWatched = true
        } else if status == false {
            dispatch_async(dispatch_get_main_queue()) {
                self.addRemoveHistory.setImage(UIImage(named: "Add"), forState: .Normal)
            }
            self.isWatched = false
        }
    }
}