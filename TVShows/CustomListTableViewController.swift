//
//  CustomListTableViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 08.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit

class CustomListTableViewController: UITableViewController {
    
    var isAllShows = Bool()
    var list = List()
    var allShows  = [TraktShow]()
    
    var shows = [TraktShow]()
    var episodes = [TraktEpisode]()
    var movies = [TraktMovie]()
    var persons = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = list.name
        getListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getListData() {
        if isAllShows == true {
            TraktManager.sharedManager.getWatched(type: .Shows, completion: { (objects, error) -> Void in
                if error == nil {
                    guard let showsArr = objects else { return }
                    for show in showsArr {
                        let newShow = TraktShow.init(json: show["show"]! as! RawJSON)
                        self.allShows.append(newShow)
                    }
                }
            })
        } else if isAllShows == false {
            TraktManager.sharedManager.getItemsForCustomList("me", listID: list.ids.trakt, completion: { (objects, error) -> Void in
                if error == nil {
                    guard let objectArr = objects else { return }
                    for obj in objectArr {
                        let objJson = JSON(obj)
                        if objJson["type"] == "show" {
                            let newShow = TraktShow.init(json: objJson["show"].dictionaryObject!)
                            self.shows.append(newShow)
                        } else if objJson["type"] == "person" {
                            let newPerson = Person.init(fromJson: objJson["person"])
                            self.persons.append(newPerson)
                        } else if objJson["type"] == "movie" {
                            let newMovie = TraktMovie.init(json: objJson["movie"].dictionaryObject!)
                            self.movies.append(newMovie)
//                        } else if objJson["type"] == "episode" {
//                            let newEpisode = TraktEpisode.init(json: objJson.dictionaryObject!)
//                            self.episodes.append(newEpisode)
                        }
                    }
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return shows.count
        } else if section == 1 {
            return movies.count
        } else if section == 2 {
            return episodes.count
        } else if section == 3 {
            return persons.count
        }
        
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
