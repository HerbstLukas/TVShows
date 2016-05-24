//
//	Progress.swift
//
//	Create by Lukas Herbst on 22/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Progress : NSObject, NSCoding{

	var aired : Int!
	var completed : Int!
	var hiddenSeasons : [AnyObject]!
	var lastWatchedAt : String!
	var nextEpisode : NextEpisode!
	var seasons : [PSeason]!
    

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
    
    override init() {
        super.init()
    }
    
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		aired = json["aired"].intValue
		completed = json["completed"].intValue
		hiddenSeasons = [AnyObject]()
		let hiddenSeasonsArray = json["hidden_seasons"].arrayValue
		for hiddenSeasonsJson in hiddenSeasonsArray{
			hiddenSeasons.append(hiddenSeasonsJson.stringValue)
		}
		lastWatchedAt = json["last_watched_at"].stringValue
		let nextEpisodeJson = json["next_episode"]
		if nextEpisodeJson != JSON.null {
			nextEpisode = NextEpisode(fromJson: nextEpisodeJson)
		}
		seasons = [PSeason]()
		let seasonsArray = json["seasons"].arrayValue
		for seasonsJson in seasonsArray{
			let value = PSeason(fromJson: seasonsJson)
			seasons.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if aired != nil{
			dictionary["aired"] = aired
		}
		if completed != nil{
			dictionary["completed"] = completed
		}
		if hiddenSeasons != nil{
			dictionary["hidden_seasons"] = hiddenSeasons
		}
		if lastWatchedAt != nil{
			dictionary["last_watched_at"] = lastWatchedAt
		}
		if nextEpisode != nil{
			dictionary["next_episode"] = nextEpisode.toDictionary()
		}
		if seasons != nil{
			var dictionaryElements = [NSDictionary]()
			for seasonsElement in seasons {
				dictionaryElements.append(seasonsElement.toDictionary())
			}
			dictionary["seasons"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         aired = aDecoder.decodeObjectForKey("aired") as? Int
         completed = aDecoder.decodeObjectForKey("completed") as? Int
         hiddenSeasons = aDecoder.decodeObjectForKey("hidden_seasons") as? [AnyObject]
         lastWatchedAt = aDecoder.decodeObjectForKey("last_watched_at") as? String
         nextEpisode = aDecoder.decodeObjectForKey("next_episode") as? NextEpisode
         seasons = aDecoder.decodeObjectForKey("seasons") as? [PSeason]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if aired != nil{
			aCoder.encodeObject(aired, forKey: "aired")
		}
		if completed != nil{
			aCoder.encodeObject(completed, forKey: "completed")
		}
		if hiddenSeasons != nil{
			aCoder.encodeObject(hiddenSeasons, forKey: "hidden_seasons")
		}
		if lastWatchedAt != nil{
			aCoder.encodeObject(lastWatchedAt, forKey: "last_watched_at")
		}
		if nextEpisode != nil{
			aCoder.encodeObject(nextEpisode, forKey: "next_episode")
		}
		if seasons != nil{
			aCoder.encodeObject(seasons, forKey: "seasons")
		}

	}

}