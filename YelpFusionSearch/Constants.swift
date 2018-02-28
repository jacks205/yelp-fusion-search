//
//  Constants.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

struct YConstants: Decodable {
    let YELP_API_URL: String
    let YELP_API_KEY: String
    
    func url(withPath path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(string: "\(self.YELP_API_URL)")
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}

let Y_CONSTANTS: YConstants = {
    guard let config = loadConfigPlist() else {
        fatalError("Unable to load configuration plist.")
    }
    return config
}()


private func loadConfigPlist() -> YConstants? {
    guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
        let data = NSData(contentsOfFile: filePath) else {
            return nil
    }
    let decoder = PropertyListDecoder()
    return try? decoder.decode(YConstants.self, from: data as Data)
}
