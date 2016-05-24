//
//	Person.swift
//
//	Create by Lukas Herbst on 8/1/2016
//	Copyright © 2016 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Person : NSObject, NSCoding{

	var biography : String!
	var birthday : String!
	var birthplace : String!
	var death : AnyObject!
	var homepage : String!
	var ids : Id!
	var images : Image!
	var name : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		biography = json["biography"].stringValue
		birthday = json["birthday"].stringValue
		birthplace = json["birthplace"].stringValue
		death = json["death"].stringValue
		homepage = json["homepage"].stringValue
		let idsJson = json["ids"]
		if idsJson != JSON.null{
			ids = Id(fromJson: idsJson)
		}
		let imagesJson = json["images"]
		if imagesJson != JSON.null {
			images = Image(fromJson: imagesJson)
		}
		name = json["name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if biography != nil{
			dictionary["biography"] = biography
		}
		if birthday != nil{
			dictionary["birthday"] = birthday
		}
		if birthplace != nil{
			dictionary["birthplace"] = birthplace
		}
		if death != nil{
			dictionary["death"] = death
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
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         biography = aDecoder.decodeObjectForKey("biography") as? String
         birthday = aDecoder.decodeObjectForKey("birthday") as? String
         birthplace = aDecoder.decodeObjectForKey("birthplace") as? String
         death = aDecoder.decodeObjectForKey("death")! as AnyObject
         homepage = aDecoder.decodeObjectForKey("homepage") as? String
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         images = aDecoder.decodeObjectForKey("images") as? Image
         name = aDecoder.decodeObjectForKey("name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if biography != nil{
			aCoder.encodeObject(biography, forKey: "biography")
		}
		if birthday != nil{
			aCoder.encodeObject(birthday, forKey: "birthday")
		}
		if birthplace != nil{
			aCoder.encodeObject(birthplace, forKey: "birthplace")
		}
		if death != nil{
			aCoder.encodeObject(death, forKey: "death")
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
		if name != nil{
			aCoder.encodeObject(name, forKey: "name")
		}

	}

}