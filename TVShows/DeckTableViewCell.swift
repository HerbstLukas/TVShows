//
//  DeckTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 17.03.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeNr: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
