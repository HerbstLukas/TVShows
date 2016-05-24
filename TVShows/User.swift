//
//	User.swift
//
//	Create by Lukas Herbst on 29/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class User : NSObject, NSCoding{

	var name : String!
	var privateField : Bool!
	var username : String!
	var vip : Bool!
	var vipEp : Bool!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		name = json["name"].stringValue
		privateField = json["private"].boolValue
		username = json["username"].stringValue
		vip = json["vip"].boolValue
		vipEp = json["vip_ep"].boolValue
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if name != nil{
			dictionary["name"] = name
		}
		if privateField != nil{
			dictionary["private"] = privateField
		}
		if username != nil{
			dictionary["username"] = username
		}
		if vip != nil{
			dictionary["vip"] = vip
		}
		if vipEp != nil{
			dictionary["vip_ep"] = vipEp
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         name = aDecoder.decodeObjectForKey("name") as? String
         privateField = aDecoder.decodeObjectForKey("private") as? Bool
         username = aDecoder.decodeObjectForKey("username") as? String
         vip = aDecoder.decodeObjectForKey("vip") as? Bool
         vipEp = aDecoder.decodeObjectForKey("vip_ep") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if name != nil{
			aCoder.encodeObject(name, forKey: "name")
		}
		if privateField != nil{
			aCoder.encodeObject(privateField, forKey: "private")
		}
		if username != nil{
			aCoder.encodeObject(username, forKey: "username")
		}
		if vip != nil{
			aCoder.encodeObject(vip, forKey: "vip")
		}
		if vipEp != nil{
			aCoder.encodeObject(vipEp, forKey: "vip_ep")
		}

	}

}