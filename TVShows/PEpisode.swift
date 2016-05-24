//
//	PEpisode.swift
//
//	Create by Lukas Herbst on 22/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PEpisode : NSObject, NSCoding{

	var completed : Bool!
	var lastWatchedAt : AnyObject!
	var number : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		completed = json["completed"].boolValue
		lastWatchedAt = json["last_watched_at"].stringValue
		number = json["number"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if completed != nil{
			dictionary["completed"] = completed
		}
		if lastWatchedAt != nil{
			dictionary["last_watched_at"] = lastWatchedAt
		}
		if number != nil{
			dictionary["number"] = number
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         completed = aDecoder.decodeObjectForKey("completed") as? Bool
         lastWatchedAt = aDecoder.decodeObjectForKey("last_watched_at")! as AnyObject
         number = aDecoder.decodeObjectForKey("number") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if completed != nil{
			aCoder.encodeObject(completed, forKey: "completed")
		}
		if lastWatchedAt != nil{
			aCoder.encodeObject(lastWatchedAt, forKey: "last_watched_at")
		}
		if number != nil{
			aCoder.encodeObject(number, forKey: "number")
		}

	}

}