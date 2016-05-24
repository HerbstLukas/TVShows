//
//	PSeason.swift
//
//	Create by Lukas Herbst on 22/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PSeason : NSObject, NSCoding{

	var aired : Int!
	var completed : Int!
	var episodes : [PEpisode]!
	var number : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!) {
		if json == nil{
			return
		}
		aired = json["aired"].intValue
		completed = json["completed"].intValue
		episodes = [PEpisode]()
		let episodesArray = json["episodes"].arrayValue
		for episodesJson in episodesArray{
			let value = PEpisode(fromJson: episodesJson)
			episodes.append(value)
		}
		number = json["number"].intValue
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
		if episodes != nil{
			var dictionaryElements = [NSDictionary]()
			for episodesElement in episodes {
				dictionaryElements.append(episodesElement.toDictionary())
			}
			dictionary["episodes"] = dictionaryElements
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
         aired = aDecoder.decodeObjectForKey("aired") as? Int
         completed = aDecoder.decodeObjectForKey("completed") as? Int
         episodes = aDecoder.decodeObjectForKey("episodes") as? [PEpisode]
         number = aDecoder.decodeObjectForKey("number") as? Int

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
		if episodes != nil{
			aCoder.encodeObject(episodes, forKey: "episodes")
		}
		if number != nil{
			aCoder.encodeObject(number, forKey: "number")
		}

	}

}