//
//  DiscoverCollectionViewController.swift
//  TVShows
//
//  Created by Lukas Herbst on 07.12.15.
//  Copyright © 2015 Lukas Herbst. All rights reserved.
//

import UIKit
import TraktKit
import Nuke

private let reuseIdentifier = "discoverCell"
private let headerIdentifier = "discoverSectionHeader"

class DiscoverCollectionViewController: UICollectionViewController {

    var popularShows = [Show]()
    var trendingShows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPopularShows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("didReceiveMemoryWarning")
    }
    
    func getPopularShows() {
        TraktManager.sharedManager.getPopularShows(page: 1, limit: 12) { (objects, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let popularShowsArr = objects else { return }
            
            for show in popularShowsArr {
                let showJson = JSON(show)
                let newShow : Show = Show.init(fromJson: showJson)
                self.popularShows.append(newShow)
                    
                if self.popularShows.count == popularShowsArr.count {
                    self.getTrendingShows()
                }
            }
        }
    }
    
    func getTrendingShows() {
        TraktManager.sharedManager.getTrendingShows(page: 1, limit: 12) { (objects, error) -> Void in
            
            // Handle error
            guard error == nil else { return }
            guard let trendingShowsArr = objects else { return }
            
            for show in trendingShowsArr {
                let showJson = JSON(show)
                let newShow : Show = Show.init(fromJson: showJson["show"])
                self.trendingShows.append(newShow)
                    
                if self.trendingShows.count == trendingShowsArr.count {
                    self.reloadCollectionView()
                }
            }
        }
    }
    
    func reloadCollectionView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView!.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 { return self.popularShows.count }
        else if section == 1 { return self.trendingShows.count }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DiscoverCollectionViewCell
        
        if indexPath.section == 0 {
            let popularShowCell = self.popularShows[indexPath.row]
            cell.configure(popularShowCell)
        }
        
        else if indexPath.section == 1  {
            let trendingShowCell = self.trendingShows[indexPath.row]
            cell.configure(trendingShowCell)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = self.collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! DiscoverSectionHeader
        
        if indexPath.section == 0 {
            headerView.headerTitle.text = "POPULAR SHOWS"
            return headerView
        } else if indexPath.section == 1 {
            headerView.headerTitle.text = "TRENDING SHOWS"
            return headerView
        }
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSize()
        
        let imageHeight : Double = 441
        let imageWidht : Double = 300
        
        // Get iPhone Size
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth :Double  = Double(screenSize.width)

        let cellWidth = screenWidth / 3
        let percentOfHeight = cellWidth / imageWidht * 100
        
        let onePercent : Double = imageHeight / 100
        let cellHeight : Double = onePercent * percentOfHeight
        
        cellSize = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
                
        return cellSize
    }
    
    // MARK: UICollectionViewDataSource
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toShowDetail"
        {
            let vc = segue.destinationViewController as! ShowDetailViewController
            vc.hidesBottomBarWhenPushed = true
            
            let indexPath = self.collectionView!.indexPathForCell(sender as! DiscoverCollectionViewCell)
            if (indexPath?.section == 0) {
                
                let showCellData = self.popularShows[indexPath!.row]
                vc.showID = String(showCellData.ids.trakt)
                vc.showTitle = showCellData.title
                vc.posterURL = showCellData.images.poster.full
                
            } else if (indexPath?.section == 1) {
                
                let showCellData = self.trendingShows[indexPath!.row]
                vc.showID = String(showCellData.ids.trakt)
                vc.showTitle = showCellData.title
                vc.posterURL = showCellData.images.poster.full
            }
        }
    }

}
