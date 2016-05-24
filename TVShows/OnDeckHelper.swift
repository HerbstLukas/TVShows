//
//  OnDeckHelper.swift
//  TVShows
//
//  Created by Lukas Herbst on 17.03.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import Foundation
import TraktKit
import CoreData

public class OnDeckHelper {
    
    // MARK: - Public
    public static let sharedHelper = OnDeckHelper()
    
    // MARK - CoreData Stack
    var coreDataStack : CoreDataStack {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        return coreDataStack
    }
    
    // MARK: - Error Enum
    public enum OnDeckError : ErrorType {
        case ErrorUnknown(message: String?)
        case ErrorGettingShows(message: String?)
        case ErrorGettingNextData(message: String?)
        case ErrorGettingProgress(message: String?)
        case ErrorCreatingNextArray(message: String?)
        case TraktConnectionError(message: String?)
        case TraktErrorUnknown(message: String?)
    }

    // MARK: - Helper Methodes
    func getNextDataFromTrakt() throws -> [OnDeckItem] {
        do { let nextArr = try getAllShowsUserHasWatched()
            return nextArr
        } catch _ {
            throw OnDeckError.ErrorGettingNextData(message: "There was an Error getting Next Data")
        }
    }
    
    func getNextDataForShow(current: OnDeckItem) throws -> OnDeckItem {
        
        do { let newOnDeck = try getProgressForOnDeckItem(current)
            return newOnDeck
        } catch _ {
            throw OnDeckError.ErrorGettingNextData(message: "There was an Error getting Next Data")
        }
    }
    
    // MARK: - Get All Shows a User has watched
    func getAllShowsUserHasWatched() throws -> [OnDeckItem] {
        
        var shows = [TraktShow]()
        var nextEpisodes = [OnDeckItem]()
        var locked = true
        
        TraktManager.sharedManager.getWatched(.Shows) { (objects, error) in
            
            guard let showsArr = objects else { return }
            
            for show in showsArr {
                let newShow = TraktShow.init(json: show["show"]! as! RawJSON)
                shows.append(newShow)
            }
            
            for show in shows {
                do { let progress = try self.getProgressForShow(show) 
                    do { 
                        let next = try self.createNextEpisode(progress, show: show)
                        nextEpisodes.append(next)
                        print("helloooo")
                    } catch _ {
                        // ERROR HANDLING
                        print("ERROR CREATING NEXT ARRAY")
                    }
                } catch _ {
                    // ERROR HANDLING
                    print("ERROR GETTING PROGRESS")
                }
            }
            // Here the creating of next Episodes Array is done - remove lock.
            print("helloooo remove lock 1")
            locked = false
        }
       
        // Waiting until the lock is removed - then return the array.
        while(locked) { wait() }
        return nextEpisodes
    }
    
    // MARK: - Get Progress for a Show
    func getProgressForShow(show: TraktShow) throws -> Progress {
        
        var progress = Progress.init()
        var locked = true
        
        TraktManager.sharedManager.getShowWatchedProgress(showID: show.ids.trakt) { (dictionary, error) in
            guard let pDict = dictionary else { return }
            
            let progressJson = JSON(pDict)
            progress = Progress.init(fromJson: progressJson)
            locked = false
            
        }
        while(locked) { wait() }
        print("returning lock progress")
        return progress
    }
    
    // MARK: - Get Progress for an old Next Episode
    func getProgressForOnDeckItem(current: OnDeckItem) throws -> OnDeckItem {
        
        var newNext = OnDeckItem.init()
        var locked = true
        TraktManager.sharedManager.getShowWatchedProgress(showID: current.showTraktID as String!) { (dictionary, error) in
            guard let pDict = dictionary else { return }
            
            let progressJson = JSON(pDict)
            let progress = Progress.init(fromJson: progressJson)
            newNext = OnDeckItem.init(oldNext: current, progress: progress)
            locked = false
        }
        
        while(locked) { wait() }
        return newNext
    }
    
    // MARK: - Create next Episode
    func createNextEpisode(progress: Progress, show: TraktShow) throws -> OnDeckItem {
        let next = OnDeckItem.init(show: show, progress: progress)
        return next
    }
    
    // MARK: - CORE DATA - Update or Save Object
    func saveOrUpdateObjectToCoreData(next: OnDeckItem) {
        
        guard let showID = next.showTraktID  else { return }
        var count = Int()
        
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
                let batchResult = try self.coreDataStack.context.executeRequest(batchUpdate) as! NSBatchUpdateResult
                let objectIDs = batchResult.result as! [NSManagedObjectID]
                for objectID in objectIDs {
                    let managedObject : NSManagedObject = self.coreDataStack.context.objectWithID(objectID)
                    self.coreDataStack.context.refreshObject(managedObject, mergeChanges: true)
                    count = count + 1
                }
            }  catch let error as NSError {
                print("Could not update \(error), \(error.userInfo)") 
            }            
        } else {
            self.saveOneEntityToCoreData(next)
            count = count + 1
        }
    }
    
    // MARK: - CORE DATA - Save one object to CoreData that does not exist by the update Mehtod
    internal func saveOneEntityToCoreData(episode : OnDeckItem) {
        
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
    
    
    // MARK: - CORE DATA - Check if a Next Update exist's in CoreData
    internal func doesNextEpisodeExist(showID : String) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Next")
        let predicate = NSPredicate(format: "showTraktID == %@", showID)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let count = coreDataStack.context.countForFetchRequest(fetchRequest, error: nil)
        
        return (count > 0) ? true : false
    }

    
    // MARK: - WAIT FOR IT
    func wait() {
        NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 1))
    }
}