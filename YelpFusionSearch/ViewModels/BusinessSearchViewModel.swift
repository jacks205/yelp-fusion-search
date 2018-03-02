//
//  BusinessSearchViewModel.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

typealias FusionSearchResultsCompletion = (BusinessSearchResult?, Error?) -> ()

class BusinessSearchViewModel {
    
    let client = YelpCacheClient()
    
    var location: CLLocation? {
        return locationService.location
    }
    
    var buisinessSearchResults: BusinessSearchResult?
    
    var businesses: [Business] = []
    
    var offset: UInt = 0
    let limit: UInt = 10
    
    func requestLocation(completion: @escaping (CLLocation?) -> ()) {
        if location != nil {
            return
        }
        locationService.getLocation { (location) in
            completion(location)
        }
    }
    
    func search(withTerm term: String, completion: @escaping FusionSearchResultsCompletion) {
        guard let location = self.location else {
            self.requestLocation(completion: { (location) in
                if let location = location {
                    self.search(withTerm: term, location: location, completion: completion)
                } else {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                }
            })
            return
        }
        search(withTerm: term, location: location, completion: completion)
    }
    
    private func search(withTerm term: String, location: CLLocation, completion: @escaping FusionSearchResultsCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let offset = self?.offset, let limit = self?.limit else { return }
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let searchResource = BusinessSearchResult.query(term: term, limit: limit, offset: offset, atLocation: location)!
            self?.client.get(resource: searchResource, completion: { (searchResult, error) in
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(self?.buisinessSearchResults, error)
                }
                
                if let searchResult = searchResult {
                    self?.buisinessSearchResults = searchResult
                    if error == nil {
                        self?.businesses += searchResult.businesses
                        self?.offset += limit
                    }
                }
                //                for (i, _) in searchResult.businesses.enumerated() {
                //                    guard let imageURL = self?.businessSearchResults?.businesses[i].imageURL else { continue }
                //                    dispatchGroup.enter()
                //                    UIImage.downloadImage(fromURL: imageURL, useCache: true, completion: { (image) in
                //                        self?.buisinessSearchResults?.businesses[i].image = image
                //                        dispatchGroup.leave()
                //                    })
                //                }
                dispatchGroup.leave()
            })
        }

    }
    
}
