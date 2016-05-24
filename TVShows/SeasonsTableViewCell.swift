//
//  SeasonsTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import Nuke

class SeasonsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var seasonNr: UILabel!
    @IBOutlet weak var episodes: UILabel!
    @IBOutlet weak var progressView: CircleProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        progressView.progress = 0.36
        progressView.backgroundColor = UIColor.clearColor()
        //progressView.centerFillColor = UIColor.clearColor()
        progressView.trackFillColor = UIColor.alizarinColor()
        progressView.trackBorderWidth = 2
        progressView.trackBorderColor = UIColor.lightGrayColor()
        progressView.trackBackgroundColor = UIColor.clearColor()
        progressView.trackWidth = 3
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(season: Season, showName: String, progress: Progress) {
        
        if season.number == 0 {
            seasonNr.text = "Specials"
        } else {
            seasonNr.text = "Season \(season.number)"
        }
        
        showTitle.text = showName
        episodes.text = "\(season.airedEpisodes) Episodes"
        
        guard let imgURL = season.images.poster.thumb else { return }
        
        if imgURL.isEmpty { } else {
            
            let req = NSURLRequest(URL: NSURL(string: imgURL)!)
            
            var request = ImageRequest(URLRequest: req)
            request.contentMode = .AspectFill
            
            Nuke.taskWithRequest(request) { response in
                switch response {
                case let .Success(image, _):
                    self.posterView.image = image
                case let .Failure(error):
                    print(error)
                }
            }.resume()
        }
        
        if season.number < progress.seasons.count {
            
            if let pSeason : PSeason = progress.seasons[season.number] {
                
                let percent = Double(pSeason.completed) / Double(pSeason.aired)
            
                progressView.progress = percent
            } else {
            
                progressView.progress = 0
            }
        } else {
            progressView.progress = 0
        }
    }
}
