//
//	Actor.swift
//
//	Create by Lukas Herbst on 8/1/2016
//	Copyright © 2016 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Actor : NSObject, NSCoding{

	var character : String!
	var person : Person!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		character = json["character"].stringValue
		let personJson = json["person"]
		if personJson != JSON.null{
			person = Person(fromJson: personJson)
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if character != nil{
			dictionary["character"] = character
		}
		if person != nil{
			dictionary["person"] = person.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         character = aDecoder.decodeObjectForKey("character") as? String
         person = aDecoder.decodeObjectForKey("person") as? Person

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if character != nil{
			aCoder.encodeObject(character, forKey: "character")
		}
		if person != nil{
			aCoder.encodeObject(person, forKey: "person")
		}

	}

}