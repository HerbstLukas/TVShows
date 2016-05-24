//
//  NextTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 12.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import CoreData
import TraktKit

class NextTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var pullToRefresh = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    var fetchedResultsController: NSFetchedResultsController!
    
    var checkInAction = UITableViewRowAction()
    var markAsWatched = UITableViewRowAction()
    
    var coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Next"

        startNext()
        
        self.dateFormatter.dateStyle = .ShortStyle
        self.dateFormatter.timeStyle = .LongStyle
        
        self.pullToRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.pullToRefresh.addTarget(self, action: #selector(NextTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(pullToRefresh)
        
        let fetchRequest = NSFetchRequest(entityName: "Next")
        fetchRequest.fetchBatchSize = 25
        
        let lastWatched = NSSortDescriptor(key: "lastWatched", ascending: false)
        fetchRequest.sortDescriptors = [lastWatched]
        
        self.fetchedResultsController = NSFetchedResultsController( fetchRequest: fetchRequest,
                                                                    managedObjectContext: self.coreDataStack.context,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        do { try self.fetchedResultsController.performFetch()
            self.reloadTableView()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func startNext() {
        TraktCoreData.sharedManager.getCountForEntity("Next") { (count, error) -> Void in
            if error == nil {
                if let objectCount = count {
                    if objectCount == 0 {
                        self.getNextDataFromTrakt({ (success, error) -> Void in
                            if error == nil {
                                if success == true {
                                    self.reloadTableView()
                                }
                            }
                        })
                    } else {
                        self.updateNextData({ (success, error) -> Void in
                            if success == true {
                                do { try self.fetchedResultsController.performFetch()
                                    self.reloadTableView()
                                } catch let error as NSError {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        })
                    }
                }
            } else {
                print(error)
            }
        }
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func refresh(sender:AnyObject) {
        startNext()
    }
    
    func endRefreshing() {
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
        self.pullToRefresh.attributedTitle = NSAttributedString(string: updateString)
        if self.pullToRefresh.refreshing {
            self.pullToRefresh.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section] 
            return currentSection.numberOfObjects
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nextCell", forIndexPath: indexPath) as! NextTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: NextTableViewCell, indexPath: NSIndexPath) {

        let next = fetchedResultsController.objectAtIndexPath(indexPath) as! Next
        dispatch_async(dispatch_get_main_queue()) {
            cell.configure(next)
        }
    }

    
    // Stuff for the Actions
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let cellData = fetchedResultsController.objectAtIndexPath(indexPath) as! Next
        
        if cellData.hasNextEpisode == true {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let checkInData = fetchedResultsController.objectAtIndexPath(indexPath) as! Next
        
        if checkInData.hasNextEpisode == true {
            
            //Create first Action - Check In
            self.checkInAction = UITableViewRowAction(style: .Normal, title: "Check In" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                let nextEp = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Next
                self.performCheckIn(nextEp)
            })
            self.checkInAction.backgroundColor = UIColor.sunflowerColor()
            
            // Create second Action - Mark as watched
            self.markAsWatched = UITableViewRowAction(style: .Normal, title: "Seen" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                let nextEp = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Next
                self.performMarkAsChecked(nextEp)
            })
            self.markAsWatched.backgroundColor = UIColor.emeraldColor()
        }
        
        // Return Actions
        return [checkInAction,markAsWatched]
    }
    
    /*
        Extensions for the NextTableViewController to handle all NSFetchedResultsControllerDelegate Methodes!
    */
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! NextTableViewCell
                self.configureCell(cell, indexPath: indexPath!)
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        let indexSet = NSIndexSet(index: sectionIndex)
        
        switch type {
            case .Insert:
                self.tableView.insertSections(indexSet, withRowAnimation: .Automatic)
            case .Delete:
                self.tableView.deleteSections(indexSet, withRowAnimation: .Automatic)
            default :
                break
        }
    }
    
    
    /*
        Trakt CheckIn 
    */
    func performCheckIn(next: Next) {
        let rjson = next.createJsonDictionary() as RawJSON
        TraktManager.sharedManager.checkIn(movie: nil, episode: rjson) { (success) -> Void in
            print(success)
        }
    }
    
    
    /*
        Trakt Mark as Checked 
    */
    func performMarkAsChecked(next: Next) {
        let nilArr = [RawJSON]()
        var arr = [RawJSON]()
        
        let jsonForEpisode = next.createJsonDictionary()
        arr.append(jsonForEpisode)

        TraktManager.sharedManager.addToHistory(movies: nilArr, shows: nilArr, episodes: arr) { (success) -> Void in
            print(success)
        }
    }
    
    func loadNextEpisodeFromTrakt(nextEp: Next) {
        TraktManager.sharedManager.getShowWatchedProgress(showID: nextEp.showTraktID!) { (dictionary, error) -> Void in
            guard let pDict = dictionary else { return }
            
            let progressJson = JSON(pDict)
            let progress = Progress.init(fromJson: progressJson)
            
        }
    }
    
    /*
        Segue Methode    
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    /*
        Trakt CoreData Helper
    */
    
    // Error Enum's
    enum TraktCoreDataError : ErrorType {
        case NoDataSaved(message: String?)
        case ErrorSaving
        case ErrorGetting
        case TraktConnectionError
    }
    
    // Completion handlers
    typealias countCompletionHandler = (count: Int?, error: NSError?) -> Void
    typealias successCompletionHandler = (success: Bool?, error: NSError?) -> Void
    typealias updateCompletionHandler = (success: Bool?, error: NSError?) -> Void
    internal typealias nextCompletionHandler = (nextEpisodes: [nextEpisode]?, error: NSError?) -> Void
    
    /*
        Start of Helper Methods
    */
    
    // Return Count for Entity
    func getCountForEntity(entityName: String, completionHandler: countCompletionHandler) -> Void {
        
        
        let fetchRequest = NSFetchRequest(entityName: entityName) 
        fetchRequest.resultType = .CountResultType 
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSNumber] 
            let count = results.first!.integerValue
                completionHandler(count: count, error: nil)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
                completionHandler(count: nil, error: error)
        } 
    }
    
    // First Next Data if we do have zero stored currently
    func getNextDataFromTrakt(completionHandler: successCompletionHandler) -> Void {
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
    func updateNextData(completionHandler: updateCompletionHandler) -> Void {
        self.getNextArrayFromTrakt { (nextEpisodes, error) -> Void in
            if error == nil {
                guard let nextArr = nextEpisodes else { return }
                var count = Int(0)
                
                for next in nextArr {
                    
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
                        batchUpdate.resultType = .UpdatedObjectIDsResultType 
                        
                        do {
                            let batchResult = try self.coreDataStack.context.executeRequest(batchUpdate) as! NSBatchUpdateResult
                            let objectIDs = batchResult.result as! [NSManagedObjectID]
                            for objectID in objectIDs {
                                let managedObject : NSManagedObject = self.coreDataStack.context.objectWithID(objectID)
                                self.coreDataStack.context.refreshObject(managedObject, mergeChanges: true)
                                count = count + 1
                            }
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

public struct nextEpisode {
    
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

// Create JSON String Data
extension Next {
    func createJsonDictionary() -> RawJSON {
        
        let now = NSDate()
        let watchedAt = now.dateToString(now)
        
        let dictionary : [String:AnyObject] = [
            "watched_at" : watchedAt,
            "trakt" : self.showTraktID!,
        ]
        
        let rwJson : RawJSON = dictionary
        
        return rwJson
    }
}
