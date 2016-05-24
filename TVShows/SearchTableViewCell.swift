//
//  SearchTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 08.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import Nuke

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showThumb: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDetail: UILabel!
    @IBOutlet weak var showYear: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(show: Show) {
        
        // Title
        if show.title.isEmpty {
            self.showTitle.text = "Title unknown!"
        } else {
            self.showTitle.text = show.title
        }
        
        // Status
        if show.status.isEmpty {
            self.showDetail.text = "Staus unknown!"
        } else {
            let status = show.status.stringByReplacingOccurrencesOfString("series", withString: "")
            self.showDetail.text = status.capitalizedString
        }
        
        // Year
        if String(show.year).isEmpty {
            self.showYear.text = "Year unknown!"
        } else {
            self.showYear.text = "\(show.year)"
        }
        
        guard let imgURL = show.images.poster.thumb else { return }
        
        if imgURL.isEmpty { } else {
            
            let req = NSURLRequest(URL: NSURL(string: imgURL)!)
            
            var request = ImageRequest(URLRequest: req)
            request.contentMode = .AspectFill
            
            Nuke.taskWithRequest(request) { response in
                switch response {
                case let .Success(image, _):
                    self.showThumb.image = image
                case let .Failure(error):
                    print(error)
                }
            }.resume()
        }
    }
}
