//
//	Episode.swift
//
//	Create by Lukas Herbst on 18/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Episode : NSObject, NSCoding{

	var availableTranslations : [AnyObject]!
	var firstAired : String!
	var ids : Id!
	var images : Image!
	var number : Int!
	var numberAbs : AnyObject!
	var overview : String!
	var rating : Float!
	var season : Int!
	var title : String!
	var updatedAt : String!
	var votes : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		availableTranslations = [AnyObject]()
		let availableTranslationsArray = json["available_translations"].arrayValue
		for availableTranslationsJson in availableTranslationsArray{
			availableTranslations.append(availableTranslationsJson.stringValue)
		}
		firstAired = json["first_aired"].stringValue
		let idsJson = json["ids"]
		if idsJson != JSON.null{
			ids = Id(fromJson: idsJson)
		}
		let imagesJson = json["images"]
		if imagesJson != JSON.null{
			images = Image(fromJson: imagesJson)
		}
		number = json["number"].intValue
		numberAbs = json["number_abs"].stringValue
		overview = json["overview"].stringValue
		rating = json["rating"].floatValue
		season = json["season"].intValue
		title = json["title"].stringValue
		updatedAt = json["updated_at"].stringValue
		votes = json["votes"].intValue
	}
    
    override init() {

    }

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if availableTranslations != nil{
			dictionary["available_translations"] = availableTranslations
		}
		if firstAired != nil{
			dictionary["first_aired"] = firstAired
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
		if numberAbs != nil{
			dictionary["number_abs"] = numberAbs
		}
		if overview != nil{
			dictionary["overview"] = overview
		}
		if rating != nil{
			dictionary["rating"] = rating
		}
		if season != nil{
			dictionary["season"] = season
		}
		if title != nil{
			dictionary["title"] = title
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
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
         availableTranslations = aDecoder.decodeObjectForKey("available_translations") as? [AnyObject]
         firstAired = aDecoder.decodeObjectForKey("first_aired") as? String
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         images = aDecoder.decodeObjectForKey("images") as? Image
         number = aDecoder.decodeObjectForKey("number") as? Int
         numberAbs = aDecoder.decodeObjectForKey("number_abs")! as AnyObject
         overview = aDecoder.decodeObjectForKey("overview") as? String
         rating = aDecoder.decodeObjectForKey("rating") as? Float
         season = aDecoder.decodeObjectForKey("season") as? Int
         title = aDecoder.decodeObjectForKey("title") as? String
         updatedAt = aDecoder.decodeObjectForKey("updated_at") as? String
         votes = aDecoder.decodeObjectForKey("votes") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if availableTranslations != nil{
			aCoder.encodeObject(availableTranslations, forKey: "available_translations")
		}
		if firstAired != nil{
			aCoder.encodeObject(firstAired, forKey: "first_aired")
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
		if numberAbs != nil{
			aCoder.encodeObject(numberAbs, forKey: "number_abs")
		}
		if overview != nil{
			aCoder.encodeObject(overview, forKey: "overview")
		}
		if rating != nil{
			aCoder.encodeObject(rating, forKey: "rating")
		}
		if season != nil{
			aCoder.encodeObject(season, forKey: "season")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if updatedAt != nil{
			aCoder.encodeObject(updatedAt, forKey: "updated_at")
		}
		if votes != nil{
			aCoder.encodeObject(votes, forKey: "votes")
		}

	}

}