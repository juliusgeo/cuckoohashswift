//
//  CuckooHashTests.swift
//  CuckooHashTests
//
//  Created by Julius Park on 4/24/18.
//  Copyright © 2018 Julius Park. All rights reserved.
//

import XCTest
@testable import CuckooHash

class CuckooHashTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingCollisions() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var hash = HashTable<Int, Any>(capacity: 10, knockoutLimit: 200)
        print(hash.bucket1)
        print(hash.bucket2)
        for i in 1...21
        {   print(i)
            let temp = HashElement<Int, Any>(key: i+1, value: "Value "+String(i))
            hash.setValue(hashElem: temp)
            print("Bucket 1 \n")
            print(hash.bucket1)
            print("Bucket 2 \n")
            print(hash.bucket2)
        }
        print("\n")
        print("\n")
        print("\n")
        print("Testing getting values\n")
        for i in 1...21
        {
            print(hash.getValue(key: i))
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
