//
//	Image.swift
//
//	Create by Lukas Herbst on 11/12/2015
//	Copyright © 2015 Greimel IT - Systemhaus. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Image : NSObject, NSCoding{

	var banner : Banner!
	var clearart : Banner!
	var fanart : Fanart!
	var logo : Banner!
	var poster : Fanart!
	var thumb : Banner!
    var screenshot : Screenshot!
    var headshot : Fanart!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		let bannerJson = json["banner"]
		if bannerJson != JSON.null{
			banner = Banner(fromJson: bannerJson)
		}
		let clearartJson = json["clearart"]
		if clearartJson != JSON.null{
			clearart = Banner(fromJson: clearartJson)
		}
		let fanartJson = json["fanart"]
		if fanartJson != JSON.null{
			fanart = Fanart(fromJson: fanartJson)
		}
		let logoJson = json["logo"]
		if logoJson != JSON.null{
			logo = Banner(fromJson: logoJson)
		}
		let posterJson = json["poster"]
		if posterJson != JSON.null{
			poster = Fanart(fromJson: posterJson)
		}
		let thumbJson = json["thumb"]
		if thumbJson != JSON.null{
			thumb = Banner(fromJson: thumbJson)
		}
        let screenshotJson = json["screenshot"]
        if screenshotJson != JSON.null{
            screenshot = Screenshot(fromJson: screenshotJson)
        }
        let headshotJson = json["headshot"]
        if headshotJson != JSON.null{
            headshot = Fanart(fromJson: headshotJson)
        }
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if banner != nil{
			dictionary["banner"] = banner.toDictionary()
		}
		if clearart != nil{
			dictionary["clearart"] = clearart.toDictionary()
		}
		if fanart != nil{
			dictionary["fanart"] = fanart.toDictionary()
		}
		if logo != nil{
			dictionary["logo"] = logo.toDictionary()
		}
		if poster != nil{
			dictionary["poster"] = poster.toDictionary()
		}
		if thumb != nil{
			dictionary["thumb"] = thumb.toDictionary()
		}
        if screenshot != nil{
            dictionary["screenshot"] = screenshot.toDictionary()
        }
        if headshot != nil{
            dictionary["headshot"] = headshot.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        banner = aDecoder.decodeObjectForKey("banner") as? Banner
        clearart = aDecoder.decodeObjectForKey("clearart") as? Banner
        fanart = aDecoder.decodeObjectForKey("fanart") as? Fanart
        logo = aDecoder.decodeObjectForKey("logo") as? Banner
        poster = aDecoder.decodeObjectForKey("poster") as? Fanart
        thumb = aDecoder.decodeObjectForKey("thumb") as? Banner
        screenshot = aDecoder.decodeObjectForKey("screenshot") as? Screenshot
        headshot = aDecoder.decodeObjectForKey("headshot") as? Fanart
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if banner != nil{
			aCoder.encodeObject(banner, forKey: "banner")
		}
		if clearart != nil{
			aCoder.encodeObject(clearart, forKey: "clearart")
		}
		if fanart != nil{
			aCoder.encodeObject(fanart, forKey: "fanart")
		}
		if logo != nil{
			aCoder.encodeObject(logo, forKey: "logo")
		}
		if poster != nil{
			aCoder.encodeObject(poster, forKey: "poster")
		}
		if thumb != nil{
			aCoder.encodeObject(thumb, forKey: "thumb")
		}
        if screenshot != nil{
            aCoder.encodeObject(screenshot, forKey: "screenshot")
        }
        if headshot != nil{
            aCoder.encodeObject(headshot, forKey: "headshot")
        }
	}
}