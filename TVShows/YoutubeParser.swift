//
//  YoutubeParser.swift
//  ShowTrakt
//
//  Created by Lukas Herbst on 04.11.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import Foundation
import Alamofire

public class YoutubeParser {
    
    public static func h264Streams(id: String, completion: ([YoutubeVideoStream]?, NSError?) -> Void ) -> Request {
        return Alamofire.request(.GET, "https://www.youtube.com/get_video_info?video_id=\(id)").responseString(completionHandler: { (response) -> Void in
            if let data = response.result.value?.dictionaryFromQueryStringComponents(), s = data["url_encoded_fmt_stream_map"] as? String {
                var streams:[YoutubeVideoStream] = []
                for vid in s.componentsSeparatedByString(",") {
                    if let v = YoutubeVideoStream(data: vid.dictionaryFromQueryStringComponents()) {
                        streams.append(v)
                    }
                }
                completion(streams, nil)
            }
            else {
                completion(nil, response.result.error)
            }
        })
    }
    
    public static func getBestQuality(streams:[YoutubeVideoStream]) -> YoutubeVideoStream? {
        for quality in ["highres", "hd1080", "hd720", "large", "medium", "small"] {
            if let stream = streams.filter({ $0.quality == quality }).first {
                return stream
            }
        }
        return nil
    }
}