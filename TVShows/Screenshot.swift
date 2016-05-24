//
//	Screenshot.swift
//
//	Create by Lukas Herbst on 18/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Screenshot : NSObject, NSCoding{

	var full : String!
	var medium : String!
	var thumb : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		full = json["full"].stringValue
		medium = json["medium"].stringValue
		thumb = json["thumb"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if full != nil{
			dictionary["full"] = full
		}
		if medium != nil{
			dictionary["medium"] = medium
		}
		if thumb != nil{
			dictionary["thumb"] = thumb
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         full = aDecoder.decodeObjectForKey("full") as? String
         medium = aDecoder.decodeObjectForKey("medium") as? String
         thumb = aDecoder.decodeObjectForKey("thumb") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if full != nil{
			aCoder.encodeObject(full, forKey: "full")
		}
		if medium != nil{
			aCoder.encodeObject(medium, forKey: "medium")
		}
		if thumb != nil{
			aCoder.encodeObject(thumb, forKey: "thumb")
		}

	}

}