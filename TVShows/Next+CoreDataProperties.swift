//
//  Next+CoreDataProperties.swift
//  TVShows
//
//  Created by Lukas Herbst on 14.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Next {

    @NSManaged var episodeNr: String?
    @NSManaged var episodeTitle: String?
    @NSManaged var fanartURL: String?
    @NSManaged var lastWatched: NSDate?
    @NSManaged var posterURL: String?
    @NSManaged var seasonNr: String?
    @NSManaged var showName: String?
    @NSManaged var showStatus: String?
    @NSManaged var showTraktID: String?
    @NSManaged var slug: String?
    @NSManaged var traktID: String?
    @NSManaged var hasNextEpisode: NSNumber?

}