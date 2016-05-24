//
//  YoutubeExtension.swift
//  ShowTrakt
//
//  Created by Lukas Herbst on 04.11.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

extension String {
    func dictionaryFromQueryStringComponents() -> [String: AnyObject] {
        var data:[String: AnyObject] = [:]
        for keyValue in self.componentsSeparatedByString("&") {
            let comps = keyValue.componentsSeparatedByString("=")
            let key = comps[0], value = comps[1]
            data[key] = value.decodedUrlFormat()
        }
        return data
    }
    
    func decodedUrlFormat() -> String {
        return self.stringByReplacingOccurrencesOfString("+", withString: " ").stringByRemovingPercentEncoding!
    }
}