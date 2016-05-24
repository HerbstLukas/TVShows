//
//	List.swift
//
//	Create by Lukas Herbst on 29/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class List : NSObject, NSCoding{

	var allowComments : Bool!
	var commentCount : Int!
	var createdAt : String!
	var descriptionField : String!
	var displayNumbers : Bool!
	var ids : Id!
	var itemCount : Int!
	var likes : Int!
	var name : String!
	var privacy : String!
	var updatedAt : String!
	var user : User!
    
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
		allowComments = json["allow_comments"].boolValue
		commentCount = json["comment_count"].intValue
		createdAt = json["created_at"].stringValue
		descriptionField = json["description"].stringValue
		displayNumbers = json["display_numbers"].boolValue
		let idsJson = json["ids"]
		if idsJson != JSON.null{
			ids = Id(fromJson: idsJson)
		}
		itemCount = json["item_count"].intValue
		likes = json["likes"].intValue
		name = json["name"].stringValue
		privacy = json["privacy"].stringValue
		updatedAt = json["updated_at"].stringValue
		let userJson = json["user"]
		if userJson != JSON.null {
			user = User(fromJson: userJson)
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if allowComments != nil{
			dictionary["allow_comments"] = allowComments
		}
		if commentCount != nil{
			dictionary["comment_count"] = commentCount
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if displayNumbers != nil{
			dictionary["display_numbers"] = displayNumbers
		}
		if ids != nil{
			dictionary["ids"] = ids.toDictionary()
		}
		if itemCount != nil{
			dictionary["item_count"] = itemCount
		}
		if likes != nil{
			dictionary["likes"] = likes
		}
		if name != nil{
			dictionary["name"] = name
		}
		if privacy != nil{
			dictionary["privacy"] = privacy
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         allowComments = aDecoder.decodeObjectForKey("allow_comments") as? Bool
         commentCount = aDecoder.decodeObjectForKey("comment_count") as? Int
         createdAt = aDecoder.decodeObjectForKey("created_at") as? String
         descriptionField = aDecoder.decodeObjectForKey("description") as? String
         displayNumbers = aDecoder.decodeObjectForKey("display_numbers") as? Bool
         ids = aDecoder.decodeObjectForKey("ids") as? Id
         itemCount = aDecoder.decodeObjectForKey("item_count") as? Int
         likes = aDecoder.decodeObjectForKey("likes") as? Int
         name = aDecoder.decodeObjectForKey("name") as? String
         privacy = aDecoder.decodeObjectForKey("privacy") as? String
         updatedAt = aDecoder.decodeObjectForKey("updated_at") as? String
         user = aDecoder.decodeObjectForKey("user") as? User

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if allowComments != nil{
			aCoder.encodeObject(allowComments, forKey: "allow_comments")
		}
		if commentCount != nil{
			aCoder.encodeObject(commentCount, forKey: "comment_count")
		}
		if createdAt != nil{
			aCoder.encodeObject(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encodeObject(descriptionField, forKey: "description")
		}
		if displayNumbers != nil{
			aCoder.encodeObject(displayNumbers, forKey: "display_numbers")
		}
		if ids != nil{
			aCoder.encodeObject(ids, forKey: "ids")
		}
		if itemCount != nil{
			aCoder.encodeObject(itemCount, forKey: "item_count")
		}
		if likes != nil{
			aCoder.encodeObject(likes, forKey: "likes")
		}
		if name != nil{
			aCoder.encodeObject(name, forKey: "name")
		}
		if privacy != nil{
			aCoder.encodeObject(privacy, forKey: "privacy")
		}
		if updatedAt != nil{
			aCoder.encodeObject(updatedAt, forKey: "updated_at")
		}
		if user != nil{
			aCoder.encodeObject(user, forKey: "user")
		}

	}

}