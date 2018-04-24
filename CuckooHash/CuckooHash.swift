//
//  CuckooHash.swift
//  CuckooHash
//
//  Created by Julius Park on 4/24/18.
//  Copyright © 2018 Julius Park. All rights reserved.
//

import Foundation
//class HashElement<T, U>{
//    var key: T
//    var value: U?
//
//    init(key: T, value: U?) {
//        self.key = key
//        self.value = value
//    }
//}
struct HashElement <Int, U>{
    let key: Int
    let value: U
    
}

struct HashTable<Key: Hashable, Value> {
    var capacity: Int
    var bucketsize: Int
    typealias Bucket = [HashElement<Int, Any>]
    var bucket1: [Bucket]
    var bucket2: [Bucket]
    init(capacity: Int, cap: Int){
        self.bucket1=Array<Bucket>(repeatElement([], count: capacity))
        self.bucket2=Array<Bucket>(repeatElement([], count: capacity))
        self.bucketsize=cap*2
        self.capacity=cap
        assert(capacity > 0)
    }
    func hash1(key: Int) -> Int {
        return key.hashValue % self.capacity
    }
    func hash2(key: Int) -> Int {
        return key.hashValue*3 % self.capacity
    }
    mutating func set(newHashElem: HashElement<Int, Any>){
        let index=hash1(key: newHashElem.key)
        if(bucket1[index].isEmpty){
            bucket1[index][0]=newHashElem
        }
    }
    
    
    
}
