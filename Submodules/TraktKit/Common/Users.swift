//
//  Users.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 10/18/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import Foundation

public enum SectionType: String {
    case Calendar = "calendar"
    case ProgressWatched = "progress_watched"
    case ProgressCollected = "progress_collected"
    case Recommendations = "recommendations"
}

public enum HiddenItemsType: String {
    case Movie = "movie"
    case Show = "show"
    case Season = "Season"
}

public enum LikeType: String {
    case Comments = "comments"
    case Lists = "lists"
}

/**
 User's with public data will return info with all GET methods. Private user's (inlcuding yourself) require valid OAuth and a friend relationship to return data.
 
 **Special username for the OAuth user**
 
 If you send valid OAuth, you can use `me` for the username to identify the OAuth user instead of needing their actual username. You can of course still use their actual username, it's up to you.
 
 **Creating New Users**
 
 Since the API uses OAuth, users can create a new account during that flow if they need to. As far as your app is concerned, you'll still receive OAuth tokens no matter if they sign in with an existing account or create a new one.
 */
private typealias Users = TraktManager
extension Users {
    
    // MARK: - Settings
    
    /**
     Get the user's settings so you can align your app's experience with what they're used to on the trakt website.
     
     🔒 OAuth Required
     */
    public func getSettings(completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/settings", authorization: true, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Follower Requests
    
    /**
     List a user's pending follow requests so they can either approve or deny them.
     
     🔒 OAuth Required
     */
    public func getFollowRequests(completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/requests", authorization: true, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Approve or Deny follower Requests
    
    /**
     Approve a follower using the `id` of the request. If the `id` is not found, was already approved, or was already denied, a `404` error will be returned.
     
     🔒 OAuth Required
    
    - parameter id: ID of the follower request. Example: `123`.
     */
    public func approveFollowRequest(requestID id: NSNumber, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/requests/\(id)", authorization: true, HTTPMethod: "POST") else { return nil }
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Deny a follower using the `id` of the request. If the `id` is not found, was already approved, or was already denied, a `404` error will be returned.
     
     🔒 OAuth Required
     
     - parameter id: ID of the follower request. Example: `123`.
     */
    public func denyFollowRequest(requestID id: NSNumber, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/requests/\(id)", authorization: true, HTTPMethod: "DELETE") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
    // MARK: - Hidden Items
    
    /**
     Get hidden items for a section. This will return an array of standard media objects. You can optionally limit the `type` of results to return.
     
     🔒 OAuth Required
     📄 Pagination
     */
    public func hiddenItems(section: SectionType, type: HiddenItemsType, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/hidden/\(section.rawValue)?type=\(type.rawValue)", authorization: true, HTTPMethod: "GET") else { return nil }
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Likes
    
    /**
     Get items a user likes. This will return an array of standard media objects. You can optionally limit the `type` of results to return.
     
     🔒 OAuth Required
     📄 Pagination
    
    - Parameter type: Possible values:  comments, lists.
     */
    public func getLikes(type: LikeType, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/likes/\(type.rawValue)", authorization: true, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Profile
    
    /**
     Get a user's profile information. If the user is private, info will only be returned if you send OAuth and are either that user or an approved follower.
     
     🔓 OAuth Optional
     */
    public func getUserProfile(username: String = "me", completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Collection
    
    /**
    Get all collected items in a user's collection. A collected item indicates availability to watch digitally or on physical media.
    
    If you add `?extended=metadata` to the URL, it will return the additional `media_type`, `resolution`, `audio`, `audio_channels` and '3d' metadata. It will use `null` if the metadata isn't set for an item.
    
    🔓 OAuth Optional
     */
    public func getCollection(username: String = "me", type: Type, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/collection/\(type.rawValue)", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Comments
    
    /**
    Returns comments a user has posted sorted by most recent.
    
    🔓 OAuth Optional
    📄 Pagination
    */
    public func getComments(username: String = "me", commentType: CommentType, type: Type2, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/comments/\(commentType.rawValue)/\(type.rawValue)", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Lists
    
    /**
    Returns all custom lists for a user. Use `users/:username/lists/:id/items` to get the actual items a specific list contains.
    
    🔓 OAuth Optional
    */
    public func getCustomLists(username: String = "me", completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/lists", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Create a new custom list. The `name` is the only required field, but the other info is recommended to ask for.
     
     🔒 OAuth Required
     
     - parameter listName: Name of the list.
     - parameter listDescription: Description for this list.
     - parameter privacy: `private`, `friends`, or `public`
     - parameter displayNumbers: Should each item be numbered?
     - parameter allowComments: Are comments allowed?
     */
    public func createCustomList(listName listName: String, listDescription: String, privacy: String = "private", displayNumbers: Bool = false, allowComments: Bool = true, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        // JSON
        var jsonString = String()
        
        jsonString += "{" // Beginning
        jsonString += "\"name\": \"\(listName)\","
        jsonString += "\"description\": \"\(listDescription)\","
        jsonString += "\"privacy\": \"\(privacy)\","
        jsonString += "\"display_numbers\": \"\(displayNumbers)\","
        jsonString += "\"allow_comments\": \"\(allowComments)\""
        jsonString += "}" // End
        
        let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Request
        guard let request = mutableRequestForURL("users/me/lists", authorization: true, HTTPMethod: "POST") else { return nil }
        request.HTTPBody = jsonData
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNewResourceCreated, completion: completion)
    }
    
    // MARK: - List
    
    /**
    Returns a single custom list. Use `users/:username/lists/:id/items` to get the actual items this list contains.
    
    🔓 OAuth Optional
    */
    public func getCustomList<T: CustomStringConvertible>(username: String = "me", listID: T, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Update a custom list by sending 1 or more parameters. If you update the list name, the original slug will still be retained so existing references to this list won't break.
     
     🔒 OAuth Required
     */
    public func updateCustomList(listID listID: NSNumber, listName: String, listDescription: String, privacy: String = "private", displayNumbers: Bool = false, allowComments: Bool = true, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        // JSON
        var jsonString = String()
        
        jsonString += "{" // Beginning
        jsonString += "\"name\": \"\(listName)\","
        jsonString += "\"description\": \"\(listDescription)\","
        jsonString += "\"privacy\": \"\(privacy)\","
        jsonString += "\"display_numbers\": \"\(displayNumbers)\","
        jsonString += "\"allow_comments\": \"\(allowComments)\""
        jsonString += "}" // End
        
        let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Request
        guard let request = mutableRequestForURL("users/me/lists/\(listID)", authorization: true, HTTPMethod: "PUT") else { return nil }
        request.HTTPBody = jsonData
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Remove a custom list and all items it contains.
     
     🔒 OAuth Required
     */
    public func DeleteCustomList(username: String = "me", listID: String, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)", authorization: true, HTTPMethod: "DELETE") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
    // MARK: - List Like
    
    /**
    Votes help determine popular lists. Only one like is allowed per list per user.
    
    🔒 OAuth Required
    */
    public func likeList<T: CustomStringConvertible>(username: String = "me", listID: T, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/like", authorization: true, HTTPMethod: "POST") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
    /**
     Remove a like on a list.
     
     🔒 OAuth Required
     */
    public func removeListLike<T: CustomStringConvertible>(username: String = "me", listID: T, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/like", authorization: true, HTTPMethod: "DELETE") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
    // MARK: - List Items
    
    /**
    Get all items on a custom list. Items can be movies, shows, seasons, episodes, or people.
    
    🔓 OAuth Optional
    */
    public func getItemsForCustomList<T: CustomStringConvertible>(username: String = "me", listID: T, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/items?extended=images", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    /**
     Add one or more items to a custom list. Items can be movies, shows, seasons, episodes, or people.
     
     🔒 OAuth Required
     */
    public func addItemToCustomList<T: CustomStringConvertible>(username: String = "me", listID: T, movies: [RawJSON], shows: [RawJSON], episodes: [RawJSON], completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/items", authorization: true, HTTPMethod: "POST") else { return nil }
        request.HTTPBody = createJsonData(movies: movies, shows: shows, episodes: episodes)
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNewResourceCreated, completion: completion)
    }
    
    // MARK: - Remove List Items
    
    /**
    Remove one or more items from a custom list.
    
    🔒 OAuth Required
    */
    public func removeItemFromCustomList<T: CustomStringConvertible>(username: String = "me", listID: T, movies: [RawJSON], shows: [RawJSON], episodes: [RawJSON], completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/items/remove", authorization: true, HTTPMethod: "POST") else { return nil }
        request.HTTPBody = createJsonData(movies: movies, shows: shows, episodes: episodes)
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - List Comments
    
    /**
    Returns all top level comments for a list. Most recent comments returned first.
    
    📄 Pagination
    */
    public func getAllListComments(username: String = "me", listID: String, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/lists/\(listID)/comments", authorization: false, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Follow
    
    /**
    If the user has a private profile, the follow request will require approval (`approved_at` will be null). If a user is public, they will be followed immediately (`approved_at` will have a date).
    
    **Note**: If this user is already being followed, a `409` HTTP status code will returned.
    
    🔒 OAuth Required
    */
    public func followUser(username: String, completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/follow", authorization: true, HTTPMethod: "POST") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNewResourceCreated, completion: completion)
    }
    
    /**
     Unfollow someone you already follow.
     
     🔒 OAuth Required
     */
    public func unfollowUser(username: String, completion: successCompletionHandler) -> NSURLSessionDataTask? {
        guard let request = mutableRequestForURL("users/\(username)/follow", authorization: true, HTTPMethod: "DELETE") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.successNoContentToReturn, completion: completion)
    }
    
    // MARK: - Followers
    
    /**
    Returns all followers including when the relationship began.
    
    🔓 OAuth Optional
    */
    public func getFollowers(username: String = "me", completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/followers", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Following
    
    /**
    Returns all user's they follow including when the relationship began.
    
    🔓 OAuth Optional
    */
    public func getFollowing(username: String = "me", completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/following", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Friends
    
    /**
    Returns all friends for a user including when the relationship began. Friendship is a 2 way relationship where each user follows the other.
    
    🔓 OAuth Optional
    */
    public func getFriends(username: String = "me", completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/friends", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - History
    
    /**
    Returns movies and episodes that a user has watched, sorted by most recent. You can optionally limit the `type` to `movies` or `episodes`. The `id` in each history item uniquely identifies the event and can be used to remove individual events by using the **POST** /sync/history/remove method. The `action` will be set to `scrobble`, `checkin`, or `watch`.
    
    Specify a `type` and trakt `id` to limit the history for just that item. If the `id` is valid, but there is no history, an empty array will be returned.
    
    🔓 OAuth Optional
    📄 Pagination
    */
    public func getWatchedHistory<T: CustomStringConvertible>(username: String = "me", type: WatchedType?, id: T?, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        var path = "users/\(username)/history"
        
        if let type = type {
            path += "/\(type.rawValue)"
            
            if let id = id { // I think a type needs to be provided if an Id was specified
                path += "/\(id)"
            }
        }
        
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL(path, authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Ratings
    
    /**
    Get a user's ratings filtered by type. You can optionally filter for a specific rating between 1 and 10.
    
    🔓 OAuth Optional
    */
    public func getUsersRatings(username: String = "me", type: Type, rating: NSNumber?, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        
        var path = "users/\(username)/ratings/\(type.rawValue)"
        
        if let rating = rating {
            path += "/\(rating)"
        }
        
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL(path, authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Watchlist
    
    /**
    Returns all items in a user's watchlist filtered by type. When an item is watched, it will be automatically removed from the watchlist. To track what the user is actively watching, use the progress APIs.
    
    🔓 OAuth Optional
    */
    public func getWatchlist(username: String = "me", type: Type, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/watchlist/\(type.rawValue)", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Watching
    
    public typealias watchingCompletionHandler = (watching: Bool, dictionary: [String: AnyObject]?, error: NSError?) -> Void
    
    /**
     Returns a movie or episode if the user is currently watching something. If they are not, it returns no data and a `204` HTTP status code.
     
     🔓 OAuth Optional
     */
    public func getWatching(username: String = "me", completion: watchingCompletionHandler) -> NSURLSessionDataTask? {
        // Should this function have a special completion handler? If it returns no data it is obvious that the user
        // is not watching anything, but checking a boolean in the completion block is also nice
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/watching", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard error == nil else {
//                #if DEBUG
//                    print("[\(__FUNCTION__)] \(error!)")
//                #endif
                completion(watching: false, dictionary: nil, error: error)
                return
            }
            
            // Check response
            guard let HTTPResponse = response as? NSHTTPURLResponse
                where HTTPResponse.statusCode == statusCodes.success ||
                    HTTPResponse.statusCode == statusCodes.successNoContentToReturn else {
                        if let HTTPResponse = response as? NSHTTPURLResponse {
                            completion(watching: false, dictionary: nil, error: self.createTraktErrorWithStatusCode(HTTPResponse.statusCode))
                        }
                        else {
                            completion(watching: false, dictionary: nil, error: TraktKitNoDataError)
                        }
                        return
            }
            
            if HTTPResponse.statusCode == statusCodes.successNoContentToReturn {
                completion(watching: false, dictionary: nil, error: nil)
                return
            }
            
            // Check data
            guard let data = data else {
                completion(watching: false, dictionary: nil, error: TraktKitNoDataError)
                return
            }
            
            do {
                if let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject] {
                    completion(watching: true, dictionary: dict, error: nil)
                }
            }
            catch let jsonSerializationError as NSError {
//                #if DEBUG
//                    print("[\(__FUNCTION__)] \(jsonSerializationError)")
//                #endif
                completion(watching: false, dictionary: nil, error: jsonSerializationError)
            }
        }
        dataTask.resume()
        
        return dataTask
    }
    
    // MARK: - Watched
    
    /**
    Returns all movies or shows a user has watched sorted by most plays.
    
    🔓 OAuth Optional
    */
    public func getWatched(username: String = "me", type: Type, completion: arrayCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/watched/\(type.rawValue)?extended=full,images", authorization: authorization, HTTPMethod: "GET") else { return nil }
        print(request.URL)
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
    
    // MARK: - Stats
    
    /**
    Returns stats about the movies, shows, and episodes a user has watched, collected, and rated.
    
    🔓 OAuth Optional
    */
    public func getStats(username: String = "me", completion: dictionaryCompletionHandler) -> NSURLSessionDataTask? {
        let authorization = username == "me" ? true : false
        guard let request = mutableRequestForURL("users/\(username)/stats", authorization: authorization, HTTPMethod: "GET") else { return nil }
        
        return performRequest(request: request, expectingStatusCode: statusCodes.success, completion: completion)
    }
}