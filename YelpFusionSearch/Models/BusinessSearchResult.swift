//
//  BusinessSearchResult.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import CoreLocation

protocol Cachable: Codable {
    static var cacheHash: String { get }
}

struct BusinessSearchResult: Cachable {
    let total: UInt
    var businesses: [Business]
    
    static var cacheHash: String {
        return "business_search_results"
    }
    
    enum RootKeys: String, CodingKey {
        case total, businesses
    }
}

extension BusinessSearchResult: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(businesses, forKey: .businesses)
    }
}

extension BusinessSearchResult {
    static func query(term: String, limit: UInt = 10, offset: UInt = 0, atLocation location: CLLocation) -> Resource<BusinessSearchResult>? {
        let termItem = URLQueryItem(name: "term", value: term)
        let amountItem = URLQueryItem(name: "limit", value: "\(limit)")
        let offsetItem = URLQueryItem(name: "offset", value: "\(offset)")
        let latitudeItem = URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)")
        let lontitudeItem = URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)")
        guard let url = Y_CONSTANTS.url(withPath: "/businesses/search", queryItems: [termItem, amountItem, offsetItem, latitudeItem, lontitudeItem]) else { return nil }
        return Resource<BusinessSearchResult>(url: url)
    }
}
