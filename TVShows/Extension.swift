//
//  Extension.swift
//  TVShows
//
//  Created by Lukas Herbst on 10.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import Foundation
import TraktKit
import UIKit

extension NSURL {
    
    // Parse URL oAuth Response
    func queryDictionary() -> [String:String] {
        let components = self.query?.componentsSeparatedByString("&")
        var dictionary = [String:String]()
        
        for pairs in components ?? [] {
            let pair = pairs.componentsSeparatedByString("=")
            if pair.count == 2 {
                dictionary[pair[0]] = pair[1]
            }
        }
        
        return dictionary
    }
}

// Screenshot
public extension UIWindow {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

// Runden hinter dem Komma
extension Double {
    var roundDownTwofractionDigits:Double {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.NoStyle
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .RoundDown
        if let stringFromDouble =  formatter.stringFromNumber(self) {
            if let doubleFromString = formatter.numberFromString( stringFromDouble ) as? Double {
                return doubleFromString
            }
        }
        return 0
    }
    var roundUpTwofractionDigits:Double {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.NoStyle
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .RoundUp
        if let stringFromDouble =  formatter.stringFromNumber(self) {
            if let doubleFromString = formatter.numberFromString( stringFromDouble ) as? Double {
                return doubleFromString
            }
        }
        return 0
    }
}

// Make NSDate From String
extension String {
    func toDateFromString() -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        return dateFromString
    }
}

// Make String from NSDate
extension NSDate {
    
    func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.stringFromDate(date)
    }
}

// Create JSON String Data
extension Episode {
    func createJsonDictionary() -> RawJSON {
        
        let now = NSDate()
        let watchedAt = now.dateToString(now)
        
        let dictionary : [String:AnyObject] = [
            "watched_at" : watchedAt,
            "trakt" : self.ids.trakt,
        ]
        
        let rwJson : RawJSON = dictionary
        
        return rwJson
    }
}

// Append String to another
extension String {
    mutating func addString(str: String) {
        self = "\(self), " + str
    }
}

// Return only two items of array
extension Array {
    func takeElements(var elementCount: Int) -> Array {
        if (elementCount > count) {
            elementCount = count
        }
        return Array(self[0..<elementCount])
    }
}

// UIImage from UIColor
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, .Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}





