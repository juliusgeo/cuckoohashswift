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
    var hashc1=Int(arc4random_uniform(9)+1)
    var hashc2=Int(arc4random_uniform(9)+1)
    var bucketsize: Int
    typealias Bucket = [HashElement<Key, Any>]
    var bucket1: [Bucket]
    var bucket2: [Bucket]
    var knockoutLimit: Int
    var knockouts = 0
    init(capacity: Int, knockoutLimit: Int){
        self.bucket1=Array<Bucket>(repeatElement([], count: capacity))
        self.bucket2=Array<Bucket>(repeatElement([], count: capacity))
        self.bucketsize=capacity
        self.capacity=capacity
        self.knockoutLimit=knockoutLimit
        assert(capacity > 0)
    }
    func hash(key: Key, space: Int) -> Int {
        switch space {
        case 1:
            return (key.hashValue/self.hashc1) % (self.capacity-1)
        case 2:
            return (key.hashValue/self.hashc2) % (self.capacity-1)
        default:
            return 0;
        }
    }
    mutating func setValue(hashElem: HashElement<Key, Any>) -> Void{
        self.set(newHashElem: hashElem, space: 1)
    }
    mutating func set(newHashElem: HashElement<Key, Any>, space: Int){
        if(knockouts>knockoutLimit){
            knockouts=0
            self.hashc1=Int(arc4random_uniform(9)+1)
            self.hashc2=Int(arc4random_uniform(9)+1)
            print("rehashed")
        }
        let index=hash(key: newHashElem.key, space: space);
        switch space {
        case 1:
            print(space)
            print("Is current index empty? ",index, self.bucket1[index].isEmpty)
            if(self.bucket1[index].isEmpty){
                self.bucket1[index]=[newHashElem]
                knockouts=0
                print("Item placed at index: ", index)
            }
            else{
                knockouts = knockouts+1
                let oldHashElem=self.bucket1[index][0]
                self.bucket1[index]=[newHashElem]
                set(newHashElem: oldHashElem, space: 2)
            }
        case 2:
            print(space)
            print("Is current index empty? ",index, self.bucket2[index].isEmpty)
            if(self.bucket2[index].isEmpty){
                self.bucket2[index]=[newHashElem]
                knockouts=0
                print(index)
            }
            else{
                knockouts = knockouts+1
                let oldHashElem=self.bucket2[index][0]
                self.bucket2[index]=[newHashElem]
                set(newHashElem: oldHashElem, space: 1)
            }
        default:
            print("Failed")
        }
        
    }
    nonmutating func getValue(key: Key) -> Any{
        //calculate indices
        let index1 = hash(key: key, space:1)
        let index2 = hash(key: key, space:2)
        let val1 = key
        let val2 = key
        //make sure that an object exists at the indices
        if(self.bucket1[index1].indices.upperBound > 0){
            let val1 = self.bucket1[index1][0].key
            print("Index exists in bucket1")
        }
        if(self.bucket2[index2].indices.upperBound > 0){
            let val2 = self.bucket2[index2][0].key
            print("Index exists in bucket2")
        }
        
        
        print("ind1:",index1, "ind2",index2)
        print("val1:",val1, "val2",val2)
        if(val1==key){
            return self.bucket1[hash(key: key, space:1)][0].value
        }
        else if(val2==key){
            return self.bucket2[hash(key: key, space:2)][0].value
        }
        else{
            return -1;
        }
        
    }
}
