//
//  HashTable.swift
//  Task3
//
//  Created by Vlad on 4/21/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    
    private(set) public var count = 0
    public var isEmpty: Bool {
        return count == 0
    }
    
    public init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>(repeating: [], count: capacity)
    }
    
    private func index(for key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return value(for: key)
        }
        set {
            if let value = newValue {
                update(value: value, for: key)
            }
        }
    }
    
    public func value(for key: Key) -> Value? {
        let index = self.index(for: key)
        return buckets[index].first { $0.key == key }?.value
    }
    
    public func update(value: Value, for key: Key) -> Value? {
        let index = self.index(for: key)
        
        if let (i, element) = buckets[index].enumerated().first(where: { $0.1.key == key }) {
            let oldValue = element.value
            buckets[index][i].value = value
            return oldValue
        }
        
        buckets[index].append((key: key, value: value))
        count += 1
        return nil
    }
}

