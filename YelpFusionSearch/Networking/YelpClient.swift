//
//  YelpClient.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

class YelpClient {
    
    private let defaultSession = URLSession.shared
    
    public func get<A>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        let request = NSMutableURLRequest(url: resource.url)
        request.addValue("Bearer \(Y_CONSTANTS.YELP_API_KEY)", forHTTPHeaderField: "Authorization")
        defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
            let result = data.flatMap(resource.parse)
            completion(result, error)
        }.resume()
    }
    
}
