//
//  CastTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 08.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import Nuke

class CastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var roleName: UILabel!
    @IBOutlet weak var `as`: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        castImageView.layer.borderWidth = 1.0
        castImageView.layer.masksToBounds = false
        castImageView.layer.borderColor = UIColor.whiteColor().CGColor
        castImageView.layer.cornerRadius = castImageView.frame.width/2
        castImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(actor: CastMember?, crewMember: CrewMember?) {
        
        var imgURL = NSURL()
        
        if let actr = actor {
            // Person Name
            if actr.person.name.isEmpty {
                self.castName.text = "Actor's name unknown"
            } else {
                self.castName.text = actr.person.name
            }
            
            // Character
            if actr.character.isEmpty {
                self.roleName.text = "Character unknown!"
            } else {
                self.roleName.text = actr.character
            }
            
            // image URL
            if let tmpUrl = actr.person.images?.headshot?.thumb {
                imgURL = tmpUrl
            }
        }
        
        if let crewMber = crewMember {
            
            // Person Name
            if crewMber.person.name.isEmpty {
                self.castName.text = "Crew Members Name unknown"
            } else {
                self.castName.text = crewMber.person.name
            }
            
            // Character
            if crewMber.job.isEmpty {
                self.roleName.text = "Job unknown!"
            } else {
                self.roleName.text = crewMber.job
            }
            
            // image URL
            if let tmpUrl = crewMber.person.images?.headshot?.thumb {
                imgURL = tmpUrl
            }
        }
        

        if imgURL.absoluteString.isEmpty {
            
            // Here do load image
            print("image URL is empty :/")
            print("learining GIT and remote git")
            
        } else {
            let req = NSURLRequest(URL: imgURL)
            
            var request = ImageRequest(URLRequest: req)
            request.contentMode = .AspectFill
            
            Nuke.taskWithRequest(request) { response in
                switch response {
                case let .Success(image, _):
                    self.castImageView.image = image
                case let .Failure(error):
                    print(error)
                }
            }.resume()
        }
    }
}
