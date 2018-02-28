//
//  Resource.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

struct Resource<A: Decodable> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL) {
        self.url = url
        self.parse = { data in
            let json = try? JSONDecoder().decode(A.self, from: data)
            return json
        }
    }
}

