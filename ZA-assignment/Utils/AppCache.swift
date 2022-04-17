//
//  AppCache.swift
//  ZA-assignment
//
//  Created by VinBrain on 17/04/2022.
//

import UIKit

class AppCache {
    
    static let shared = AppCache()
    
    // MARK: Properties
    
    private var storage: [String: UIImage]
    
    private init() {
        storage = [:]
    }

    // MARK: Add to storage

    func add(_ item: UIImage, for key: String) {
        guard storage[key] == nil else {
            return
        }
        storage[key] = item
    }
    
    // MARK: Empty storage
    
    func empty() {
        storage.removeAll()
        storage = [:]
    }
    
    // MARK: Get from storage

    func get(for key: String) -> UIImage? {
        let result = storage[key]
        return result
    }
}
