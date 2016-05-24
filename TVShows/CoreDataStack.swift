//
//  CoreDataStack.swift
//  TVShows
//
//  Created by Lukas Herbst on 19.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    // Define your Modal Name
    let modelName = "TVShows"
    
    // 1. Get URL
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    /*  
        2.
        NSManagedObjectContext’s initializer takes a concurrency type enumeration.
        Chapter 10 covers the different types of concurrency types in detail. For now you initialize this managed context using MainQueueConcurrencyType.
        Your managed context isn’t very useful until you connect it to an raywenderlich.com Page 66 Core Data by Tutorials Second Edition Chapter 3: The Core Data Stack NSPersistentStoreCoordinator.
        You do this by setting the managed context’s persistentStoreCoordinator property to stack’s store coordinator.
    */
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    /*  
        3.
        Doing this lazy-loads the store coordinator.
        Remember that the store coordinator mediates between the NSManagedObjectModel and the persistent store(s),
        so you’ll need to create a managed model and at least one persistent store.
    */
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStoreWithType( NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            print("Error adding persistent store.")
        }
        return coordinator
    }()
    
    /*  
        4.
        First, you initialize the store coordinator using CoreDataStack’s NSManagedObjectModel, which lazy-loads it into existence (covered below).
        Second you attach a persistent store to the store coordinator. The way you create a persistent store is somewhat unintuitive—you don’t initialize it directly.
        Instead, the persistent store coordinator hands you an NSPersistentStore object as a side effect of attaching a persistent store type. 
        You simply have to specify the store type (NSSQLiteStoreType in this case), the URL location of the store file and some configuration options.
    */
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle() .URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    // 5. Context Save Methode
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}