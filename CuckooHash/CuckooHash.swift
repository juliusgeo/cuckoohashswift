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
    let value: U
}

struct HashTable<Key: Hashable, Value> {
    var capacity: Int
    var bucketsize: Int
    typealias Bucket = [HashElement<Key, Any>]
    var bucket1: [Bucket]
    var bucket2: [Bucket]
    var knockoutLimit: Int
    var knockouts = 0
    init(capacity: Int, knockoutLimit: Int){
        self.bucket1=Array<Bucket>(repeatElement([], count: capacity))
        self.bucket2=Array<Bucket>(repeatElement([], count: capacity))
        self.bucketsize=capacity*2
        self.capacity=capacity
        self.knockoutLimit=knockoutLimit
        assert(capacity > 0)
    }
    func hash(key: Key, space: Int) -> Int {
        switch space {
        case 1:
            return (key.hashValue) % (self.capacity-1)
        case 2:
            return (key.hashValue*3) % (self.capacity-1)
        default:
            return 0;
        }
    }
    mutating func setValue(hashElem: HashElement<Key, Any>) -> Void{
        self.set(newHashElem: hashElem, space: 1)
    }
    mutating func set(newHashElem: HashElement<Key, Any>, space: Int){
        if(knockouts>knockoutLimit){
            return
        }
        
        let index=hash(key: newHashElem.key, space: space);
        switch space {
        case 1:
            if(self.bucket1[index].isEmpty){
                self.bucket1[index]=[newHashElem]
                knockouts=0
            }
            else{
                knockouts = knockouts+1
                let oldHashElem=self.bucket1[index][0]
                set(newHashElem: oldHashElem, space: 2)
            }
        case 2:
            if(self.bucket2[index].isEmpty){
                self.bucket2[index]=[newHashElem]
                knockouts=0
            }
            else{
                knockouts = knockouts+1
                let oldHashElem=self.bucket2[index][0]
                set(newHashElem: oldHashElem, space: 1)
            }
        default:
            print("Failed")
        }
        
    }
    nonmutating func getValue(key: Key) -> Any{
        if(self.bucket1[hash(key: key, space:1)][0].key==key){
            return self.bucket1[hash(key: key, space:1)][0].value
        }
        else if(self.bucket2[hash(key: key, space: 2)][0].key==key){
            return self.bucket2[hash(key: key, space: 2)][0].value
        }
        else{
            return -1;
        }
        
    }
}
