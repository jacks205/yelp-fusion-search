//
//  UIImage.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImage {
    
    /// Downloads image from specified URL, and saves to local image cache.
    ///
    /// - Parameters:
    ///   - url: URL for image
    ///   - useCache: Check cache for image first; defaults to true
    ///   - completion: Provides retrieved image. Will be nil if unable to retrieve image.
    class func downloadImage(fromURL url: URL, useCache: Bool = true, completion: ((UIImage?) -> Void)?) {
        if useCache {
            // Check cache for image and return
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                completion?(cachedImage)
                return
            }
        }
        // Default to downloading from url and caching
        if  let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion?(image)
            return
        }
        completion?(nil)
    }
}
