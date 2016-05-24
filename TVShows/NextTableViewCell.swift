//
//  NextTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import Nuke

class NextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var labelOnTop: UILabel!
    @IBOutlet weak var labelInTheMiddle: UILabel!
    @IBOutlet weak var labelOnTheBottom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(next: Next) {
        
        dispatch_async(dispatch_get_main_queue()) {

        var url = String()
        
        if next.episodeNr == "0" {
            if (next.showStatus! == "ended") {
                if let showName = next.showName {
                    self.labelOnTop.text = showName
                } else {
                    self.labelOnTop.text = "Show name unknown."
                }
                    self.labelInTheMiddle.text = "You're done! Series ended - all watched!"
                    self.labelOnTheBottom.text = ""
            } else if (next.showStatus! == "returning series") {
                if let showName = next.showName {
                    self.labelOnTop.text = showName
                } else {
                    self.labelOnTop.text = "Show name unknown."
                }
                    self.labelInTheMiddle.text = "All seen - check back next Season!"
                    self.labelOnTheBottom.text = ""
            }  
        } else {
            if let showName = next.showName {
                self.labelOnTop.text = showName
            } else {
                self.labelOnTop.text = "Show name unknown."
            }
            
            if let nextTitle = next.episodeTitle {
                self.labelInTheMiddle.text = nextTitle.uppercaseString
            } else {
                self.labelInTheMiddle.text = "Episode title unknown!"
            }
            
            if let sNr = next.seasonNr {
                if let eNr = next.episodeNr {
                    self.labelOnTheBottom.text = "S0\(sNr)E0\(eNr)"
                }
            }
        }
     
        if let fanart = next.fanartURL {
            url = fanart
        } else {
            if let poster = next.posterURL {
                url = poster
            }
        }
        
        if url.isEmpty {
            self.cellImageView.image?.imageWithColor(UIColor.blackColor())
        } else {
                        
            let req = NSURLRequest(URL: NSURL(string: url)!)
            
            var request = ImageRequest(URLRequest: req)
            request.contentMode = .AspectFill
            
            Nuke.taskWithRequest(request) { response in
                switch response {
                case let .Success(image, _):
                        self.cellImageView.image = image
                case let .Failure(error):
                    print(error)
                }
            }.resume()
        }
        }
    }
}
