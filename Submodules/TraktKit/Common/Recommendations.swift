//
//  Recommendations.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 11/14/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import Foundation

extension TraktManager {
    
    // MARK: - Public
    
    /**
     Personalized movie recommendations for a user. Results returned with the top recommendation first.
     
     🔒 OAuth: Required
     */
    public func getRecommendedMovies(completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        return self.getRecommendations(.Movies, completion: completion)
    }
    
    /**
     Hide a movie from getting recommended anymore.
     
     🔒 OAuth: Required
     */
    public func hideRecommendedMovie<T: CustomStringConvertible>(movieID id: T, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        return hideRecommendation(type: .Movies, id: id, completion: completion)
    }
    
    /**
     Personalized show recommendations for a user. Results returned with the top recommendation first.
     
     🔒 OAuth: Required
     */
    public func getRecommendedShows(completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        return self.getRecommendations(.Shows, completion: completion)
    }
    
    /**
     Hide a show from getting recommended anymore.
     
     🔒 OAuth: Required
     */
    public func hideRecommendedShow<T: CustomStringConvertible>(showID id: T, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        return hideRecommendation(type: .Shows, id: id, completion: completion)
    }
    
    // MARK: - Private
    
    private func getRecommendations(type: WatchedType, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        // Request
        guard let request = mutableRequestForURL("recommendations/\(type)", authorization: true, HTTPMethod: "GET") else {
            completion(objects: nil, error: TraktKitNoDataError)
            return nil
        }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    private func hideRecommendation<T: CustomStringConvertible>(type type: WatchedType, id: T, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        // Request
        guard let request = mutableRequestForURL("recommendations/\(type)/\(id)", authorization: true, HTTPMethod: "DELETE") else {
            completion(success: false)
            return nil
        }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
}
