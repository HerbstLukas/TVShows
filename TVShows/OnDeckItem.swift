//
//  OnDeckItem.swift
//  TVShows
//
//  Created by Lukas Herbst on 20.03.16.
//  Copyright © 2016 Lukas Herbst. All rights reserved.
//

import Foundation
import TraktKit

// MARK: - Internal Next Struct 
struct OnDeckItem {
    
    var showName : String?
    var title : String?
    var slug : String?
    var seasonNumber : Int?
    var episodeNumber : Int?
    var trakt : String?
    var lastWatched : NSDate?
    var status : String?
    var fanartURL : String?
    var showPosterURL : String?
    var showTraktID: String?
    var hasNextEpisode: NSNumber?
    
    // Initialize
    init(show: TraktShow, progress: Progress) { 
        
        // Begin checking for nil values
        if show.title.isEmpty {
            showName = "Now show name known."
        } else {
            showName = show.title
        }
        
        // Check for nil in nextEpisode
        if progress.nextEpisode == nil {
            hasNextEpisode = false
        } else {
            hasNextEpisode = true
            
            if let nextTitle = progress.nextEpisode.title {
                if nextTitle.isEmpty {
                    title = "Now title knwon."
                } else {
                    title = nextTitle
                }
            } else {
                title = "Now title knwon."
            }
            
            if let nextSlugTmp = progress.nextEpisode.ids.slug {
                if nextSlugTmp.isEmpty {
                    slug = nil
                } else {
                    slug = nextSlugTmp
                }
            } else {
                slug = nil
            }
            
            if let nextSeason = progress.nextEpisode.season {
                if String(nextSeason).isEmpty {
                    seasonNumber = nil
                } else {
                    seasonNumber = nextSeason
                }
            } else {
                seasonNumber = nil
            }
            
            if let nextEpisode = progress.nextEpisode.number {
                if String(nextEpisode).isEmpty {
                    episodeNumber = nil
                } else {
                    episodeNumber = nextEpisode
                }
            } else {
                episodeNumber = nil
            }
            
            if let traktTmp = progress.nextEpisode.ids.trakt {
                if String(traktTmp).isEmpty {
                    trakt = nil
                } else {
                    trakt = String(traktTmp)
                }
            } else {
                trakt = nil
            }
        }
        
        // Here is the end of nextEpisode checks
        
        if let watchedTmp = progress.lastWatchedAt {
            if watchedTmp.isEmpty {
                lastWatched = nil
            } else {
                lastWatched = watchedTmp.toDateFromString()
            }
        }
        
        
        if let statusTmp = show.status {
            if statusTmp.isEmpty {
                status = "No status known." 
            } else {
                status = statusTmp
            }
        }
        
        
        if let showPosterTmp = show.images?.poster?.thumb {
            if showPosterTmp.absoluteString.isEmpty {
                showPosterURL = nil
            } else {
                showPosterURL = showPosterTmp.absoluteString
            }
        }
        
        
        if let fanartURLTmp = show.images?.fanart?.thumb {
            
            if fanartURLTmp.absoluteString.isEmpty {
                fanartURL = nil
            } else {
                fanartURL = fanartURLTmp.absoluteString
            }
        }   
    }
    
    init(oldNext: OnDeckItem, progress: Progress) {
        
        // Begin checking for nil values
        if let showNameTmp = oldNext.showName {
            showName = showNameTmp
        } else {
            showName = nil
        }
        
        // Check for nil in nextEpisode
        if progress.nextEpisode == nil {
            hasNextEpisode = false
        } else {
            hasNextEpisode = true
            
            if let nextTitle = progress.nextEpisode.title {
                if nextTitle.isEmpty {
                    title = "Now title knwon."
                } else {
                    title = nextTitle
                }
            } else {
                title = "Now title knwon."
            }
            
            if let nextSlugTmp = progress.nextEpisode.ids.slug {
                if nextSlugTmp.isEmpty {
                    slug = nil
                } else {
                    slug = nextSlugTmp
                }
            } else {
                slug = nil
            }
            
            if let nextSeason = progress.nextEpisode.season {
                if String(nextSeason).isEmpty {
                    seasonNumber = nil
                } else {
                    seasonNumber = nextSeason
                }
            } else {
                seasonNumber = nil
            }
            
            if let nextEpisode = progress.nextEpisode.number {
                if String(nextEpisode).isEmpty {
                    episodeNumber = nil
                } else {
                    episodeNumber = nextEpisode
                }
            } else {
                episodeNumber = nil
            }
            
            if let traktTmp = progress.nextEpisode.ids.trakt {
                if String(traktTmp).isEmpty {
                    trakt = nil
                } else {
                    trakt = String(traktTmp)
                }
            } else {
                trakt = nil
            }
        }
        
        // Here is the end of nextEpisode checks
        
        if let watchedTmp = progress.lastWatchedAt {
            if watchedTmp.isEmpty {
                lastWatched = nil
            } else {
                lastWatched = watchedTmp.toDateFromString()
            }
        }
        
        
        if let statusTmp = oldNext.status {
            if statusTmp.isEmpty {
                status = "No status known." 
            } else {
                status = statusTmp
            }
        }
        
        
        if let showPosterTmp = oldNext.showPosterURL {
            if showPosterTmp.isEmpty {
                showPosterURL = nil
            } else {
                showPosterURL = showPosterTmp
            }
        }
        
        
        if let fanartURLTmp = oldNext.fanartURL {
            
            if fanartURLTmp.isEmpty {
                fanartURL = nil
            } else {
                fanartURL = fanartURLTmp
            }
        }
    }
    
    init() {
    }
}