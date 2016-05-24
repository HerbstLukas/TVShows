//
//  YoutubeVideoStream.swift
//  ShowTrakt
//
//  Created by Lukas Herbst on 04.11.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import Foundation

public class YoutubeVideoStream {
    
    public let type: String!
    public let quality: String!
    public let url: NSURL!
    
    public init?(data: [String: AnyObject]) {
        if let t = data["type"] as? String, uri = (data["url"] as? String)?.decodedUrlFormat(), q = data["quality"] as? String, u = NSURL(string: uri) where t.containsString("mp4") {
            type = t
            quality = q
            url = u
        }
        else {
            type = nil
            quality = nil
            url = nil
            
            return nil
        }
    }
    
}