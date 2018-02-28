//
//  Business.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

struct Business {
    let name: String
    let distance: Double
    let imageURL: URL?
    
    enum RootKeys: String, CodingKey {
        case name, distance, imageURL = "image_url"
    }
}


extension Business: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        name = try container.decode(String.self, forKey: .name)
        distance = try container.decode(Double.self, forKey: .distance)
        let imageURLString = try container.decode(String.self, forKey: .imageURL)
        imageURL = URL(string: imageURLString)
    }
}

extension Business: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distance, forKey: .distance)
        if let imageURLString = imageURL?.absoluteString {
            try container.encode(imageURLString, forKey: .imageURL)
        }
    }
}
