//
//	Id.swift
//
//	Create by Lukas Herbst on 11/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Id : NSObject, NSCoding{

	var imdb : String!
	var slug : String!
	var tmdb : Int!
	var trakt : Int!
	var tvdb : Int!
	var tvrage : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		imdb = json["imdb"].stringValue
		slug = json["slug"].stringValue
		tmdb = json["tmdb"].intValue
		trakt = json["trakt"].intValue
		tvdb = json["tvdb"].intValue
		tvrage = json["tvrage"].intValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if imdb != nil{
			dictionary["imdb"] = imdb
		}
		if slug != nil{
			dictionary["slug"] = slug
		}
		if tmdb != nil{
			dictionary["tmdb"] = tmdb
		}
		if trakt != nil{
			dictionary["trakt"] = trakt
		}
		if tvdb != nil{
			dictionary["tvdb"] = tvdb
		}
		if tvrage != nil{
			dictionary["tvrage"] = tvrage
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         imdb = aDecoder.decodeObjectForKey("imdb") as? String
         slug = aDecoder.decodeObjectForKey("slug") as? String
         tmdb = aDecoder.decodeObjectForKey("tmdb") as? Int
         trakt = aDecoder.decodeObjectForKey("trakt") as? Int
         tvdb = aDecoder.decodeObjectForKey("tvdb") as? Int
         tvrage = aDecoder.decodeObjectForKey("tvrage") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if imdb != nil{
			aCoder.encodeObject(imdb, forKey: "imdb")
		}
		if slug != nil{
			aCoder.encodeObject(slug, forKey: "slug")
		}
		if tmdb != nil{
			aCoder.encodeObject(tmdb, forKey: "tmdb")
		}
		if trakt != nil{
			aCoder.encodeObject(trakt, forKey: "trakt")
		}
		if tvdb != nil{
			aCoder.encodeObject(tvdb, forKey: "tvdb")
		}
		if tvrage != nil{
			aCoder.encodeObject(tvrage, forKey: "tvrage")
		}

	}

}