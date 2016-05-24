//
//  CoreDataHelper.swift
//  TVShows
//
//  Created by Lukas Herbst on 19.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import Foundation
import TraktKit
import CoreData

public class TraktCoreData {
    
    // MARK: Public
    public static let sharedManager = TraktCoreData()
    
    var coreDataStack : CoreDataStack {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        return coreDataStack
    }
    
    // Error Enum's
    public enum TraktCoreDataError : ErrorType {
        case NoDataSaved(message: String?)
        case ErrorSaving
        case ErrorGetting
        case TraktConnectionError
    }
    
    // Completion handlers
    public typealias countCompletionHandler = (count: Int?, error: NSError?) -> Void
    public typealias successCompletionHandler = (success: Bool?, error: NSError?) -> Void
    public typealias updateCompletionHandler = (success: Bool?, error: NSError?) -> Void
    internal typealias nextCompletionHandler = (nextEpisodes: [nextEpisode]?, error: NSError?) -> Void
    
    // Internal Next Struct 
    struct nextEpisode {
        
        var showName : String?
        var title : String?
        var slug : String?
        var seasonNumber : Int?
        var episodeNumber : Int?
        var trakt : String?
        var lastWatched : NSDate?
        var status : String?
        var fanartURL : String?
        var showPosterURL : String?
        var showTraktID: String?
        var hasNextEpisode: NSNumber?
    }
    
    /*
        Start of Helper Methods
    */
    
    // Return Count for Entity
    public func getCountForEntity(entityName: String, completionHandler: countCompletionHandler) -> Void {
        
        
        let fetchRequest = NSFetchRequest(entityName: entityName) 
        fetchRequest.resultType = .CountResultType 
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSNumber] 
            let count = results.first!.integerValue
            print("\(count) objects found for \(entityName)")
            completionHandler(count: count, error: nil)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            completionHandler(count: nil, error: error)
        } 
    }
    
    // First Next Data if we do have zero stored currently
    public func getNextDataFromTrakt(completionHandler: successCompletionHandler) -> Void {
        self.getNextArrayFromTrakt { (nextEpisodes, error) -> Void in
            if error == nil {
                guard let nextArr = nextEpisodes else { return }
                let entity = NSEntityDescription.entityForName("Next", inManagedObjectContext: self.coreDataStack.context)
                for episode in nextArr {
                    let next = Next(entity: entity!,insertIntoManagedObjectContext: self.coreDataStack.context)
            
                    next.showName = episode.showName
                    next.slug = episode.slug
                    next.episodeTitle = episode.title
                    next.seasonNr = String(episode.seasonNumber) // INT
                    next.episodeNr = String(episode.episodeNumber) // INT
                    next.traktID = String(episode.trakt) // NSNumber
                    next.lastWatched = episode.lastWatched
                    next.showStatus = episode.status
                    next.fanartURL = episode.fanartURL
                    next.posterURL = episode.showPosterURL
                    next.showTraktID = episode.showTraktID
                    next.hasNextEpisode = episode.hasNextEpisode

                }
                self.coreDataStack.saveContext()
                print("Imported \(nextArr.count) Shows")
                completionHandler(success: true, error: nil)
            }
        }
    }
    
    // Update Items in CoreData 
    public func updateNextData(completionHandler: updateCompletionHandler) -> Void{
        self.getNextArrayFromTrakt { (nextEpisodes, error) -> Void in
            if error == nil {
                guard let nextArr = nextEpisodes else { return }
                
                for next in nextArr {
                    
                    var count = Int()
                    
                    guard let showID = next.showTraktID  else { return }
                    
                    if self.doesNextEpisodeExist(showID) {
                        
                        let batchUpdate = NSBatchUpdateRequest(entityName: "Next")
                        batchUpdate.predicate = NSPredicate(format: "showTraktID == %@", showID)
                        
                        batchUpdate.propertiesToUpdate = [
                            "showName" : next.showName!,
                            "slug" : next.slug!,
                            "episodeTitle" : next.title!,
                            "seasonNr" : String(next.seasonNumber!),
                            "episodeNr" : String(next.episodeNumber!), 
                            "traktID" : String(next.trakt!), 
                            "lastWatched" : next.lastWatched!,
                            "showStatus" : next.status!,
                            "fanartURL" : next.fanartURL!,
                            "posterURL" : next.showPosterURL!,
                            "showTraktID" : next.showTraktID!,
                            "hasNextEpisode" : next.hasNextEpisode!
                        ]
                        
                        batchUpdate.affectedStores = self.coreDataStack.context.persistentStoreCoordinator!.persistentStores
                        batchUpdate.resultType = .UpdatedObjectsCountResultType 
                        
                        do {
                            let batchResult = try self.coreDataStack.context .executeRequest(batchUpdate) as! NSBatchUpdateResult
                            count = count + 1 
                            print("Records updated \(count)") 
                        } 
                            catch let error as NSError {
                            print("Could not update \(error), \(error.userInfo)") 
                        }
                        
                    } else {
                        self.saveOneEntityToCoreData(next)
                        count = count + 1
                    }
                    
                    if count == nextArr.count {
                        completionHandler(success: true, error: nil)
                        print(count)
                    }
                }
                
            } else {
                // Here Error Handling
            }
        }
    }
    
    
    /*
        Internal Helper Methods
    */
    
    // Get complete Next Data from Trakt
    internal func getNextArrayFromTrakt(completionHandler: nextCompletionHandler) {
        
        var allShows = [TraktShow]()
        var progressArr = [Progress]()
        var nextArr = [nextEpisode]()
    
        TraktManager.sharedManager.getWatched(type: .Shows) { (objects, error) -> Void in
    
            // Check for Error
            guard error == nil else { return }
            guard let showsArr = objects else { return }
            for show in showsArr {
                let newShow = TraktShow.init(json: show["show"]! as! RawJSON)
                allShows.append(newShow)
            }
    
            if allShows.count == showsArr.count {
                for show in allShows {

                let showID = show.ids.trakt
    
                TraktManager.sharedManager.getShowWatchedProgress(showID: showID, completion: { (dictionary, error) -> Void in
                    guard let pDict = dictionary else { return }
    
                    let progressJson = JSON(pDict)
                    let progress = Progress.init(fromJson: progressJson)
                    progressArr.append(progress)
    
                        var showName = String()
                        var epTitle = String()
                        var slug = String()
                        var seasonNumber = Int()
                        var episodeNumber = Int()
                        var trakt = String()
                        var lastWatched = NSDate()
                        var status = String()
                        var showPosterURL = String()
                        var fanartURL = String()
                        let showTraktID = String(show.ids.trakt)
                        var hasNextEpisode = NSNumber()
    
                        // Begin checking for nil values
                        if show.title.isEmpty {
                            showName = "Now show name known."
                        } else {
                            showName = show.title
                        }
                        
                        // Check for nil in nextEpisode
                        if progress.nextEpisode == nil {
                            hasNextEpisode = false
                        } else {
                            hasNextEpisode = true
                    
                            if let nextTitle = progress.nextEpisode.title {
                                if nextTitle.isEmpty {
                                    epTitle = ""
                                } else {
                                    epTitle = nextTitle
                                }
                            } else {
                                epTitle = ""
                            }
    
                            if let nextSlugTmp = progress.nextEpisode.ids.slug {
                                if nextSlugTmp.isEmpty {
                                    slug = ""
                                } else {
                                    slug = nextSlugTmp
                                }
                            } else {
                                slug = ""
                            }
    
                            if let nextSeason = progress.nextEpisode.season {
                                if String(nextSeason).isEmpty {
                                    seasonNumber = 0
                                } else {
                                    seasonNumber = nextSeason
                                }
                            } else {
                                seasonNumber = 0
                            }
    
                            if let nextEpisode = progress.nextEpisode.number {
                                if String(nextEpisode).isEmpty {
                                    episodeNumber = 0
                                } else {
                                    episodeNumber = nextEpisode
                                }
                            } else {
                                episodeNumber = 0
                            }
    
                            if let traktTmp = progress.nextEpisode.ids.trakt {
                                if String(traktTmp).isEmpty {
                                    trakt = ""
                                } else {
                                    trakt = String(traktTmp)
                                }
                            } else {
                                trakt = ""
                            }
                        }
                    
                        // Here is the end of nextEpisode checks
                    
                        if let watchedTmp = progress.lastWatchedAt {
                            if watchedTmp.isEmpty {
                                // No last watched date
                                // TO DO
                            } else {
                                lastWatched = watchedTmp.toDateFromString()
                            }
                        }
                    
                       
                        if let statusTmp = show.status {
                            if statusTmp.isEmpty {
                               status = "No status known." 
                            } else {
                                status = statusTmp
                            }
                        }

                        
                    if let showPosterTmp = show.images?.poster?.thumb {
                        if showPosterTmp.absoluteString.isEmpty {
                            showPosterURL = ""
                        } else {
                            showPosterURL = showPosterTmp.absoluteString
                        }
                    }

                    
                        if let fanartURLTmp = show.images?.fanart?.thumb {
                                                        
                            if fanartURLTmp.absoluteString.isEmpty {
                                fanartURL = ""
                            } else {
                                fanartURL = fanartURLTmp.absoluteString
                            }
                        }
    
    
                        // Here is the end of checking for nil values
                        // Lets Build the nextEpisode Struct
                        let next = nextEpisode (
                            showName: showName,
                            title: epTitle,
                            slug: slug,
                            seasonNumber: seasonNumber,
                            episodeNumber: episodeNumber,
                            trakt: trakt,
                            lastWatched: lastWatched,
                            status: status,
                            fanartURL: fanartURL,
                            showPosterURL: showPosterURL,
                            showTraktID : showTraktID,
                            hasNextEpisode: hasNextEpisode
                        )
    
                        nextArr.append(next)
                        
                        if nextArr.count == allShows.count {
                            completionHandler(nextEpisodes: nextArr, error: nil)
                        }
                    })
                }
            }
        }
    }
    
    // save one object to CoreData that does not exist by the update Mehtod
    internal func saveOneEntityToCoreData(episode : nextEpisode) {
        
        let entity = NSEntityDescription.entityForName("Next", inManagedObjectContext: self.coreDataStack.context)
        let next = Next(entity: entity!,insertIntoManagedObjectContext: self.coreDataStack.context)
        
        guard let sNr = episode.seasonNumber else { return }
        guard let eNr = episode.episodeNumber else { return }
        
        next.showName = episode.showName
        next.slug = episode.slug
        next.episodeTitle = episode.title
        next.seasonNr = String(sNr) // INT
        next.episodeNr = String(eNr) // INT
        next.traktID = String(episode.trakt) // NSNumber
        next.lastWatched = episode.lastWatched
        next.showStatus = episode.status
        next.fanartURL = episode.fanartURL
        next.posterURL = episode.showPosterURL
        next.showTraktID = episode.showTraktID
        next.hasNextEpisode = episode.hasNextEpisode
        
        self.coreDataStack.saveContext()
        print("saved new nextEpisode \(episode.title) from \(episode.showName)")

    }
    
    
    // check if a Next Update exist's in CoreData
    internal func doesNextEpisodeExist(showID : String) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Next")
        let predicate = NSPredicate(format: "showTraktID == %@", showID)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: nil)
        
        return (count > 0) ? true : false
    }
    
}

