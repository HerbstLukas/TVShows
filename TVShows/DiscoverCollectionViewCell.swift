//
//  DiscoverCollectionViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 10.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import Nuke

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    
    
    func configure(cellData : Show) {
        guard let imgURL = cellData.images.poster.thumb else { return }
        
        if imgURL.isEmpty { } else {
            
            let req = NSURLRequest(URL: NSURL(string: imgURL)!)
            
            var request = ImageRequest(URLRequest: req)
            request.contentMode = .AspectFill
            
            Nuke.taskWithRequest(request) { response in
                switch response {
                case let .Success(image, _):
                    self.showImage.image = image
                case let .Failure(error):
                    print(error)
                }
            }.resume()
        }
    }
}
