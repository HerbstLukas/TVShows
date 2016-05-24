//
//	Show.swift
//
//	Create by Lukas Herbst on 11/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Show : NSObject, NSCoding{

	var airedEpisodes : Int!
	var airs : Air!
	var availableTranslations : [String]!
	var certification : String!
	var country : String!
	var firstAired : String!
	var genres : [String]!
	var homepage : String!
	var ids : Id!
	var images : Image!
	var language : String!
	var network : String!
	var overview : String!
	var rating : Float!
	var runtime : Int!
	var status : String!
	var title : String!
	var trailer : String!
	var updatedAt : String!
	var votes : Int!
	var year : Int!
    
    
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
		airedEpisodes = json["aired_episodes"].intValue
		let airsJson = json["airs"]
		if airsJson != JSON.null{
			airs = Air(fromJson: airsJson)
		}
		availableTranslations = [String]()
		let availableTranslationsArray = json["available_translations"].arrayValue
		for availableTranslationsJson in availableTranslationsArray{
			availableTranslations.append(availableTranslationsJson.stringValue)
		}
		certification = json["certification"].stringValue
		country = json["country"].stringValue
		firstAired = json["first_aired"].stringValue
		genres = [String]()
		let genresArray = json["genres"].arrayValue
		for genresJson in genresArray{
			genres.append(genresJson.stringValue)
		}
		homepage = json["homepage"].stringValue
		let idsJson = json["ids"]
		if idsJson != JSON.null{
			ids = Id(fromJson: idsJson)
		}
		let imagesJson = json["images"]
		if imagesJson != JSON.null{
			images = Image(fromJson: imagesJson)
		}
		language = json["language"].stringValue
		network = json["network"].stringValue
		overview = json["overview"].stringValue
		rating = json["rating"].floatValue
		runtime = json["runtime"].intValue
		status = json["status"].stringValue
		title = json["title"].stringValue
		trailer = json["trailer"].stringValue
		updatedAt = json["updated_at"].stringValue
		votes = json["votes"].intValue
		year = json["year"].intValue
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
		if airs != nil{
			dictionary["airs"] = airs.toDictionary()
		}
		if availableTranslations != nil{
			dictionary["available_translations"] = availableTranslations
		}
		if certification != nil{
			dictionary["certification"] = certification
		}
		if country != nil{
			dictionary["country"] = country
		}
		if firstAired != nil{
			dictionary["first_aired"] = firstAired
		}
		if genres != nil{
			dictionary["genres"] = genres
		}
		if homepage != nil{
			dictionary["homepage"] = homepage
		}
		if ids != nil{
			dictionary["ids"] = ids.toDictionary()
		}
		if images != nil{
			dictionary["images"] = images.toDictionary()
		}
		if language != nil{
			dictionary["language"] = language
		}
		if network != nil{
			dictionary["network"] = network
		}
		if overview != nil{
			dictionary["overview"] = overview
		}
		if rating != nil{
			dictionary["rating"] = rating
		}
		if runtime != nil{
			dictionary["runtime"] = runtime
		}
		if status != nil{
			dictionary["status"] = status
		}
		if title != nil{
			dictionary["title"] = title
		}
		if trailer != nil{
			dictionary["trailer"] = trailer
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if votes != nil{
			dictionary["votes"] = votes
		}
		if year != nil{
			dictionary["year"] = year
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
         airs = aDecoder.decodeObjectForKey("airs") as? Air
         availableTranslations = aDecoder.decodeObjectForKey("available_translations") as? [String]
         certification = aDecoder.decodeObjectForKey("certification") as? String
         country = aDecoder.decodeObjectForKey("country") as? String
         firstAired = aDecoder.decodeObjectForKey("first_aired") as? String
         genres = aDecoder.decodeObjectForKey("genres") as? [String]
         homepage = aDecoder.decodeObjectForKey("homepage") as? String
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         images = aDecoder.decodeObjectForKey("images") as? Image
         language = aDecoder.decodeObjectForKey("language") as? String
         network = aDecoder.decodeObjectForKey("network") as? String
         overview = aDecoder.decodeObjectForKey("overview") as? String
         rating = aDecoder.decodeObjectForKey("rating") as? Float
         runtime = aDecoder.decodeObjectForKey("runtime") as? Int
         status = aDecoder.decodeObjectForKey("status") as? String
         title = aDecoder.decodeObjectForKey("title") as? String
         trailer = aDecoder.decodeObjectForKey("trailer") as? String
         updatedAt = aDecoder.decodeObjectForKey("updated_at") as? String
         votes = aDecoder.decodeObjectForKey("votes") as? Int
         year = aDecoder.decodeObjectForKey("year") as? Int

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
		if airs != nil{
			aCoder.encodeObject(airs, forKey: "airs")
		}
		if availableTranslations != nil{
			aCoder.encodeObject(availableTranslations, forKey: "available_translations")
		}
		if certification != nil{
			aCoder.encodeObject(certification, forKey: "certification")
		}
		if country != nil{
			aCoder.encodeObject(country, forKey: "country")
		}
		if firstAired != nil{
			aCoder.encodeObject(firstAired, forKey: "first_aired")
		}
		if genres != nil{
			aCoder.encodeObject(genres, forKey: "genres")
		}
		if homepage != nil{
			aCoder.encodeObject(homepage, forKey: "homepage")
		}
		if ids != nil{
			aCoder.encodeObject(ids, forKey: "ids")
		}
		if images != nil{
			aCoder.encodeObject(images, forKey: "images")
		}
		if language != nil{
			aCoder.encodeObject(language, forKey: "language")
		}
		if network != nil{
			aCoder.encodeObject(network, forKey: "network")
		}
		if overview != nil{
			aCoder.encodeObject(overview, forKey: "overview")
		}
		if rating != nil{
			aCoder.encodeObject(rating, forKey: "rating")
		}
		if runtime != nil{
			aCoder.encodeObject(runtime, forKey: "runtime")
		}
		if status != nil{
			aCoder.encodeObject(status, forKey: "status")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if trailer != nil{
			aCoder.encodeObject(trailer, forKey: "trailer")
		}
		if updatedAt != nil{
			aCoder.encodeObject(updatedAt, forKey: "updated_at")
		}
		if votes != nil{
			aCoder.encodeObject(votes, forKey: "votes")
		}
		if year != nil{
			aCoder.encodeObject(year, forKey: "year")
		}
	}
}