//
//  TermSearchViewModel.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/28/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

class TermSearchViewModel {
    
    public var pastSearchTerms: Set<String> = []
    
    func add(searchTerm: String) {
        pastSearchTerms.insert(searchTerm.lowercased())
    }
    
    func requestLocation() {
        locationService.getLocation { (location) in
            
        }
    }
    
}
