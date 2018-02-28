//
//  BusinessSearchViewModel.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import CoreLocation

class BusinessSearchViewModel {
    
    let client = YelpCacheClient()
    
    var location: CLLocation?
    
    var buisinessSearchResults: BusinessSearchResult?
    
    var businesses: [Business] {
        return buisinessSearchResults?.businesses ?? []
    }
    
    func requestLocation() {
        if location != nil {
            return
        }
        locationService.getLocation { (location) in
            self.location = location
        }
    }
    
    func search(withTerm term: String, completion: @escaping (BusinessSearchResult?, Error?) -> ()) {
        guard let location = self.location else {
            completion(nil, nil)
            return
        }
        DispatchQueue.global().async { [weak self] in
            let searchResource = BusinessSearchResult.query(term: term, atLocation: location)!
            self?.client.get(resource: searchResource, completion: { (searchResult, error) in
                self?.buisinessSearchResults = searchResult
                DispatchQueue.main.async {
                    completion(searchResult, error)
                }
            })
        }
    }
    
}
