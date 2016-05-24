//
//	Season.swift
//
//	Create by Lukas Herbst on 15/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Season : NSObject, NSCoding{

	var airedEpisodes : Int!
	var episodeCount : Int!
	var ids : Id!
	var images : Image!
	var number : Int!
	var overview : AnyObject!
	var rating : Float!
	var votes : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		airedEpisodes = json["aired_episodes"].intValue
		episodeCount = json["episode_count"].intValue
		let idsJson = json["ids"]
		if idsJson != JSON.null{
			ids = Id(fromJson: idsJson)
		}
		let imagesJson = json["images"]
		if imagesJson != JSON.null{
			images = Image(fromJson: imagesJson)
		}
		number = json["number"].intValue
		overview = json["overview"].stringValue
		rating = json["rating"].floatValue
		votes = json["votes"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if airedEpisodes != nil{
			dictionary["aired_episodes"] = airedEpisodes
		}
		if episodeCount != nil{
			dictionary["episode_count"] = episodeCount
		}
		if ids != nil{
			dictionary["ids"] = ids.toDictionary()
		}
		if images != nil{
			dictionary["images"] = images.toDictionary()
		}
		if number != nil{
			dictionary["number"] = number
		}
		if overview != nil{
			dictionary["overview"] = overview
		}
		if rating != nil{
			dictionary["rating"] = rating
		}
		if votes != nil{
			dictionary["votes"] = votes
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         airedEpisodes = aDecoder.decodeObjectForKey("aired_episodes") as? Int
         episodeCount = aDecoder.decodeObjectForKey("episode_count") as? Int
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         images = aDecoder.decodeObjectForKey("images") as? Image
         number = aDecoder.decodeObjectForKey("number") as? Int
         overview = aDecoder.decodeObjectForKey("overview")! as AnyObject
         rating = aDecoder.decodeObjectForKey("rating") as? Float
         votes = aDecoder.decodeObjectForKey("votes") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if airedEpisodes != nil{
			aCoder.encodeObject(airedEpisodes, forKey: "aired_episodes")
		}
		if episodeCount != nil{
			aCoder.encodeObject(episodeCount, forKey: "episode_count")
		}
		if ids != nil{
			aCoder.encodeObject(ids, forKey: "ids")
		}
		if images != nil{
			aCoder.encodeObject(images, forKey: "images")
		}
		if number != nil{
			aCoder.encodeObject(number, forKey: "number")
		}
		if overview != nil{
			aCoder.encodeObject(overview, forKey: "overview")
		}
		if rating != nil{
			aCoder.encodeObject(rating, forKey: "rating")
		}
		if votes != nil{
			aCoder.encodeObject(votes, forKey: "votes")
		}

	}

}