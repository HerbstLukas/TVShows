//
//  Watching.swift
//  TVShows
//
//  Created by Lukas Herbst on 09.01.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import Foundation


class Watching : NSObject, NSCoding{
    
    var action : String!
    var episode : Episode!
    var expiresAt : String!
    var show : Show!
    var startedAt : String!
    var type : String!
    
    override init() {
        super.init()
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        action = json["action"].stringValue
        let episodeJson = json["episode"]
        if episodeJson != JSON.null{
            episode = Episode(fromJson: episodeJson)
        }
        expiresAt = json["expires_at"].stringValue
        let showJson = json["show"]
        if showJson != JSON.null{
            show = Show(fromJson: showJson)
        }
        startedAt = json["started_at"].stringValue
        type = json["type"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if action != nil{
            dictionary["action"] = action
        }
        if episode != nil{
            dictionary["episode"] = episode.toDictionary()
        }
        if expiresAt != nil{
            dictionary["expires_at"] = expiresAt
        }
        if show != nil{
            dictionary["show"] = show.toDictionary()
        }
        if startedAt != nil{
            dictionary["started_at"] = startedAt
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        action = aDecoder.decodeObjectForKey("action") as? String
        episode = aDecoder.decodeObjectForKey("episode") as? Episode
        expiresAt = aDecoder.decodeObjectForKey("expires_at") as? String
        show = aDecoder.decodeObjectForKey("show") as? Show
        startedAt = aDecoder.decodeObjectForKey("started_at") as? String
        type = aDecoder.decodeObjectForKey("type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if action != nil{
            aCoder.encodeObject(action, forKey: "action")
        }
        if episode != nil{
            aCoder.encodeObject(episode, forKey: "episode")
        }
        if expiresAt != nil{
            aCoder.encodeObject(expiresAt, forKey: "expires_at")
        }
        if show != nil{
            aCoder.encodeObject(show, forKey: "show")
        }
        if startedAt != nil{
            aCoder.encodeObject(startedAt, forKey: "started_at")
        }
        if type != nil{
            aCoder.encodeObject(type, forKey: "type")
        }
    }
}