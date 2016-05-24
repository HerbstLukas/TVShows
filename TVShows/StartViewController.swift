//
//  StartViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 07.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import SafariServices
import CoreData

let loginSuccess = "is.lks.userIsNowLogedIn"
let loginError = "is.lks.userLoginError"

class StartViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var coreDataStack = CoreDataStack()
    var traktAuth : SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userIsNowLogedIn", name: loginSuccess, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorWhileLogin", name: loginError, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("didReveiveMemoryWarning")
    }
    
    // oAuth using SFSafariViewController
    @IBAction func startOAuth(sender: AnyObject) {
        
        guard let oathURL = TraktManager.sharedManager.oauthURL else { return }
        
        traktAuth = SFSafariViewController(URL: oathURL)
        traktAuth!.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogin", name: loginSuccess, object: nil)
        
        self.presentViewController(traktAuth!, animated: true, completion: nil)
    }
    
    // Open Register Page in Safari
    @IBAction func viewRegisterPage(sender: AnyObject) {
        
        guard let url = NSURL(string: "https://trakt.tv/auth/join") else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    // SFSafariViewController dismiss function
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Succes - Show TabBarController
    func userIsNowLogedIn() {
        dispatch_async(dispatch_get_main_queue(), {
            
            // Remove SFSafariViewController
            self.traktAuth!.dismissViewControllerAnimated(true, completion: nil)
            
            // Go to Main Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! MainTabBarController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainTabBar
        })

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func errorWhileLogin() {
        
        
        let alertController = UIAlertController(title: "Sorry.", message: "There was an error while the login. Please try again later.", preferredStyle: .Alert)
        
        let contactSupport = UIAlertAction(title: "Contact support", style: .Cancel) { (action) in }
        alertController.addAction(contactSupport)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
