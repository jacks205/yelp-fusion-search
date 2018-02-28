//
//  YelpSerializer.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import Foundation

class FileStorage {
    
    func store<A: Encodable>(item: A, atFilePath filePath: String) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedData = try jsonEncoder.encode(item)
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(filePath, isDirectory: false)
            FileManager.default.createFile(atPath: url.path, contents: encodedData, attributes: nil)
        } catch {
            
        }
    }
    
    func read<A: Decodable>(filePath: String, asType type: A.Type) -> A? {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(filePath, isDirectory: false)
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(type, from: data)
                return item
            } catch {
                
            }
        } else {
            
        }
        return nil
    }
    
}
