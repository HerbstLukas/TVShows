//
//  CoreShow+CoreDataProperties.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CoreShow {

    @NSManaged var episode: String?
    @NSManaged var poster: String?
    @NSManaged var raiting: String?
    @NSManaged var season: String?
    @NSManaged var title: String?
    @NSManaged var traktID: String?
    @NSManaged var year: String?
    @NSManaged var status: String?
    @NSManaged var fanart: String?

}