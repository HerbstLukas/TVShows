//
//  Episodes.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 11/26/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import Foundation

extension TraktManager {
    // TODO: Hold a private variable that constructs the common base URL
    
    /**
     Returns a single episode's details. All date and times are in UTC and were calculated using the episode's `air_date` and show's `country` and `air_time`.
     
     **Note**: If the `first_aired` is unknown, it will be set to `null`.
     */
    public func getEpisodeSummary<T: CustomStringConvertible>(showID id: T, seasonNumber season: NSNumber, episodeNumber episode: NSNumber, extended: extendedType, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("shows/\(id)/seasons/\(season)/episodes/\(episode)?=\(extended)", authorization: false, HTTPMethod: "GET") else {
            return nil
        }
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Returns all top level comments for an episode. Most recent comments returned first.
     
     📄 Pagination
     */
    public func getEpisodeComments<T: CustomStringConvertible>(showID id: T, seasonNumber season: NSNumber, episodeNumber episode: NSNumber, completion: commentsCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("shows/\(id)/seasons/\(season)/episodes/\(episode)/comments", authorization: false, HTTPMethod: "GET") else {
            return nil
        }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Returns rating (between 0 and 10) and distribution for an episode.
     */
    public func getEpisodeRatings<T: CustomStringConvertible>(showID id: T, seasonNumber: NSNumber, episodeNumber: NSNumber, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("shows/\(id)/seasons/\(seasonNumber)/episodes/\(episodeNumber)/ratings", authorization: false, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Returns lots of episode stats.
     */
    public func getEpisodeStatistics<T: CustomStringConvertible>(showID id: T, seasonNumber season: NSNumber, episodeNumber episode: NSNumber, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("shows/\(id)/seasons/\(season)/episodes/\(episode)/stats", authorization: false, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Returns all users watching this episode right now.
     */
    public func getUsersWatchingEpisode<T: CustomStringConvertible>(showID id: T, seasonNumber season: NSNumber, episodeNumber episode: NSNumber, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("shows/\(id)/seasons/\(season)/episodes/\(episode)/watching", authorization: false, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
}
