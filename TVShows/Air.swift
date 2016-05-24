//
//	Air.swift
//
//	Create by Lukas Herbst on 11/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Air : NSObject, NSCoding{

	var day : String!
	var time : String!
	var timezone : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		day = json["day"].stringValue
		time = json["time"].stringValue
		timezone = json["timezone"].stringValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if day != nil{
			dictionary["day"] = day
		}
		if time != nil{
			dictionary["time"] = time
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         day = aDecoder.decodeObjectForKey("day") as? String
         time = aDecoder.decodeObjectForKey("time") as? String
         timezone = aDecoder.decodeObjectForKey("timezone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if day != nil{
			aCoder.encodeObject(day, forKey: "day")
		}
		if time != nil{
			aCoder.encodeObject(time, forKey: "time")
		}
		if timezone != nil{
			aCoder.encodeObject(timezone, forKey: "timezone")
		}

	}

}