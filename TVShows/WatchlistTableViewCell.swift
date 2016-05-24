//
//  WatchlistTableViewCell.swift
//  TVShows
//
//  Created by Lukas Herbst on 29.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listUpdated: UILabel!
    @IBOutlet weak var listItems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = colorView.frame.size.width / 2
        colorView.clipsToBounds = true
        colorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        colorView.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(list: List) {
        
        listName.text = list.name
        listItems.text = String(list.itemCount)
        
        if let date = list.updatedAt {
            if date.isEmpty {
                self.listUpdated.text = "No date known."
            } else {
                let dateFromString = date.toDateFromString()
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                self.listUpdated.text = dateFormatter.stringFromDate(dateFromString)
            }
        } else {
            self.listUpdated.text = "No date known."
        }

    }
}