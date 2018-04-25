//
//  CuckooHash.swift
//  CuckooHash
//
//  Created by Julius Park on 4/24/18.
//  Copyright © 2018 Julius Park. All rights reserved.
//

import Foundation
struct HashElement <Int, U>{
    let key: Int
    var value: U
}

struct HashTable<Key: Hashable, Value> {
    typealias Bucket = [HashElement<Key, Any>]
    let capacity: Int
    let bucketsize: Int
    let numBuckets: Int
    var buckets = [[Bucket]]()
    let knockoutLimit: Int
    var knockouts = 0
    let hashcs: [Int]
    
    init(numBuckets: Int, capacity: Int, knockoutLimit: Int){
        for i in 0...numBuckets-1{
            print(i)
            self.buckets.append(Array<Bucket>(repeatElement([], count: capacity)))
        }
        self.hashcs = Array<Int>(repeatElement(Int(arc4random_uniform(9)+1), count: numBuckets))
        self.bucketsize=capacity
        self.capacity=capacity
        self.numBuckets = numBuckets
        self.knockoutLimit=knockoutLimit
        assert(capacity > 0)
    }
    func hash(key: Key, space: Int) -> Int {
        return (key.hashValue/self.hashcs[space]) % (self.capacity-1)
    }
    mutating func setValue(hashElem: HashElement<Key, Any>) -> Void{
        self.set(newHashElem: hashElem, space: 1)
    }
    mutating func set(newHashElem: HashElement<Key, Any>, space: Int){
        if(knockouts>knockoutLimit){
            knockouts=0
            print("Failed to insert")
            return
        }
        let index=hash(key: newHashElem.key, space: space);
        if(self.buckets[space][index].indices.upperBound > 0){
            knockouts = knockouts+1
            let oldHashElem=self.buckets[space][index][0]
            self.buckets[space][index]=[newHashElem]
            set(newHashElem: oldHashElem, space: (space+1)%self.numBuckets)
        }
        else{
            self.buckets[space][index]=[newHashElem]
            knockouts=0
        }
        
    }
    nonmutating func getLoadFactor() -> Float
    {   var inc=0
        for bucket in buckets{
            for elem in bucket{
                if(elem.indices.upperBound > 0){
                    inc = inc+1
                }
            }
        }
        let totalCap = self.numBuckets*self.capacity
        return (Float(inc)/Float(totalCap))as Float
    }
    
    nonmutating func getValue(key: Key) -> Any{
        for i in 0...self.numBuckets-1 {
            let index = hash(key: key, space: i)
            if(self.buckets[i][index].indices.upperBound > 0){
                if(self.buckets[i][index][0].key == key){
                    return self.buckets[i][index][0].value
                }
            }
        }
        return -1
    }
    mutating func updateValue(key: Key, newValue: Value){
        for i in 0...self.numBuckets-1 {
            let index = hash(key: key, space: i)
            if(self.buckets[i][index].indices.upperBound > 0){
                if(self.buckets[i][index][0].key == key){
                    self.buckets[i][index][0].value = newValue
                }
            }
        }
    }
}
