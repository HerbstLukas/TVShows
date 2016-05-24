//
//	NextEpisode.swift
//
//	Create by Lukas Herbst on 22/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NextEpisode : NSObject, NSCoding{

	var ids : Id!
	var number : Int!
	var season : Int!
	var title : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		let idsJson = json["ids"]
		if idsJson != JSON.null {
			ids = Id(fromJson: idsJson)
		}
		number = json["number"].intValue
		season = json["season"].intValue
		title = json["title"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if ids != nil{
			dictionary["ids"] = ids.toDictionary()
		}
		if number != nil{
			dictionary["number"] = number
		}
		if season != nil{
			dictionary["season"] = season
		}
		if title != nil{
			dictionary["title"] = title
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         number = aDecoder.decodeObjectForKey("number") as? Int
         season = aDecoder.decodeObjectForKey("season") as? Int
         title = aDecoder.decodeObjectForKey("title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if ids != nil{
			aCoder.encodeObject(ids, forKey: "ids")
		}
		if number != nil{
			aCoder.encodeObject(number, forKey: "number")
		}
		if season != nil{
			aCoder.encodeObject(season, forKey: "season")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}

	}

}