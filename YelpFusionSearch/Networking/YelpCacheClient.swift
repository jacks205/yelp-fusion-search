//
//  YelpCacheClient.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

class YelpCacheClient: YelpClient {
    override func get<A: Cachable>(resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        super.get(resource: resource) { (item, error) in
            let cacheStorage = FileStorage()
            if let item = item {
                cacheStorage.store(item: item, atFilePath: "\(A.cacheHash).json")
            } else if let cachedItem = cacheStorage.read(filePath: "\(A.cacheHash).json", asType: A.self) {
                completion(cachedItem, error)
                return
            }
            completion(item, error)
        }
    }
}
