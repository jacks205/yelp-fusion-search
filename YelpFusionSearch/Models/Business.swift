//
//  Business.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import UIKit

struct Business {
    let name: String
    let distance: Measurement<Unit>
    let imageURL: URL?
    var image: UIImage?
    
    enum RootKeys: String, CodingKey {
        case name, distance, imageURL = "image_url"
    }
}


extension Business: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let meters = try container.decode(Double.self, forKey: .distance)
        distance = Measurement(value: meters, unit: UnitLength.meters)
        let imageURLString = try container.decode(String.self, forKey: .imageURL)
        imageURL = URL(string: imageURLString)
    }
}

extension Business: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKeys.self)
        try container.encode(name, forKey: .name)
        let meters = distance.value
        try container.encode(meters, forKey: .distance)
        if let imageURLString = imageURL?.absoluteString {
            try container.encode(imageURLString, forKey: .imageURL)
        }
    }
}
