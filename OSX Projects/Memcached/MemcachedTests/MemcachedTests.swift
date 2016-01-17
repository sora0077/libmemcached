//
//  MemcachedTests.swift
//  MemcachedTests
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Memcached


struct Options: ServerConnectionOption {
    
    var host: String = "localhost"
}


class MemcachedTests: QuickSpec {
    
    var conn: Connection!
    
    override func spec() {
        beforeEach {
            let pool = ConnectionPool(options: Options())
            self.conn = try! pool.connection()
        }
        describe("memcached") {
            context("getter, setter") {
                it("has no value, if not set") {
                    do {
                        let val = try self.conn.stringForKey("novalue")
                        expect(val).to(beNil())
                    } catch {
                        XCTFail()
                    }
                }
                it("has value, when you set the value before") {
                    do {
                        try self.conn.set("test", forKey: "key")
                        let val = try self.conn.stringForKey("key")
                        XCTAssertEqual(val, "test")
                        expect(val).to(equal("test"))
                    } catch {
                        XCTFail()
                    }
                }
                it("has no value, if value is expired") {
                    do {
                        try self.conn.set("test", forKey: "expire", expire: 1)
                        expect(try self.conn.stringForKey("expire")).to(equal("test"))
                        expect(try self.conn.stringForKey("expire")).toEventually(beNil(), timeout: 1.1)
                    } catch {
                        XCTFail()
                    }
                }
            }
        }
    }
}
