//
//  AppDelegate.swift
//  TVShows
//
//  Created by Lukas Herbst on 07.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import CoreData
import TraktKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    let loginSuccess = "is.lks.userIsNowLogedIn"
    let loginError = "is.lks.userLoginError"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set Trakt API Data
        TraktManager.sharedManager.setClientID("76ed1dab4a7c01fdd81981b19a30dfad9c6923fab5b4cca7f05f23846167527f",
                                               clientSecret: "f360d617eab4e8b3124d52437df69e47d885e3a725e73bb2bf8aed3fd2bb6a86",
                                               redirectURI: "tvshows://auth/callback")
        
        // Set Colors for UITabBar
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.alizarinColor()], forState:.Selected)
        UITabBar.appearance().tintColor = UIColor.alizarinColor()
        UIBarButtonItem.appearance().tintColor = UIColor.alizarinColor()
        UINavigationBar.appearance().tintColor = UIColor.alizarinColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Function to check Login
        if TraktManager.sharedManager.isSignedIn == true {
            
            print("\(TraktManager.sharedManager.isSignedIn) -  YES is loged in")
                        
            //TraktCoreData.sharedManager.coreDataStack = coreDataStack
            
        } else if TraktManager.sharedManager.isSignedIn == false {
            print("\(TraktManager.sharedManager.isSignedIn) -  NO is not loged in")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("StartViewController") as! StartViewController
            window?.rootViewController = loginVC            
            
        } else {
            print("\(TraktManager.sharedManager.isSignedIn) -  Oh Shit - some crazy error happend -.-")
        }
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let queryDict = url.queryDictionary() // Parse URL
        
        if url.host == "auth" {
            
            if let code = queryDict["code"] { // Get authorization code
                TraktManager.sharedManager.getTokenFromAuthorizationCode(code, completionHandler: { (success) -> Void in
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(self.loginSuccess, object: self)
                })
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(self.loginError, object: self)
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveContext()
    }
}

