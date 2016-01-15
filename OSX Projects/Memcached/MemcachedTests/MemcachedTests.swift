//
//  MemcachedTests.swift
//  MemcachedTests
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import XCTest
@testable import Memcached

class MemcachedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        let a = "日本語😬👨‍👩‍👧‍👧".dataUsingEncoding(NSUTF8StringEncoding)!
        self.measureBlock {
            // Put the code you want to measure the time of here.
            for _ in 0..<500000 {
                _ = String(data: a, encoding: NSUTF8StringEncoding)
            }
        }
    }
    
    func testPerformanceExample2() {
        // This is an example of a performance test case.
        
        let b = "日本語😬👨‍👩‍👧‍👧".cStringUsingEncoding(NSUTF8StringEncoding)!
        self.measureBlock {
            // Put the code you want to measure the time of here.
            for _ in 0..<500000 {
                _ = String.fromCString(b)
            }
        }
    }
    
}
