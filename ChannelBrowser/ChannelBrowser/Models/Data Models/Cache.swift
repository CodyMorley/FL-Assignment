//
//  Cache.swift
//  ChannelBrowser
//
//  Created by Cody Morley on 5/20/21.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var storedCache: [Key : Value] = [:]
    private var queue = DispatchQueue(label: .cacheID)
    
    func cache(for key: Key ,value: Value) {
        queue.async {
            self.storedCache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            storedCache[key]
        }
    }
}
