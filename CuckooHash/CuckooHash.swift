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
    typealias Bucket = [HashElement<Key, Any>]
    var bucket1: [Bucket]
    var bucket2: [Bucket]
    init(capacity: Int){
        self.bucket1=Array<Bucket>(repeatElement([], count: capacity))
        self.bucket2=Array<Bucket>(repeatElement([], count: capacity))
        self.bucketsize=capacity*2
        self.capacity=capacity
        assert(capacity > 0)
    }
    func hash1(key: Key) -> Int {
        return (key.hashValue) % self.capacity
    }
    func hash2(key: Key) -> Int {
        return (key.hashValue/3) % self.capacity
    }
    mutating func setValue(hashElem: HashElement<Key, Any>) -> Void{
        var bucket1=self.bucket1
        var bucket2=self.bucket2
        self.set(newHashElem: hashElem, bucket1: &bucket1, bucket2: &bucket2, space: 1)
    }
    mutating func set(newHashElem: HashElement<Key, Any>, bucket1: inout Array<Bucket>, bucket2: inout Array<Bucket>, space: Int){
        let index=0;
        if(space==1){
            let index=hash1(key: newHashElem.key)
        }
        else if(space==2){
            let index=hash2(key: newHashElem.key)
        }
        if(bucket1[index].isEmpty){
            bucket1[index]=[newHashElem]
        }
        else{
            let oldHashElem=bucket1[index][0]
            set(newHashElem: oldHashElem, bucket1: &bucket2, bucket2: &bucket1, space: (space+1)%2)
        }
    }
    nonmutating func getValue(key: Key) -> Any{
        if(self.bucket1[hash1(key: key)][0].key==key){
            return self.bucket1[hash1(key: key)][0].value
        }
        else if(self.bucket2[hash2(key: key)][0].key==key){
            return self.bucket2[hash2(key: key)][0].value
        }
        else{
            return -1;
        }
        
    }
}
