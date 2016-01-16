//
//  Connection.swift
//  Memcached
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import libmemcached

extension Connection {
    
    public enum Error: ErrorType {
        case ConvertError
        case ConnectionError(String)
    }
    
    private enum Value {
        case String(Swift.String)
        case Data(NSData)

        static let stringFlag: UInt32 = 1
        static let dataFlag: UInt32 = 2
        
        var flags: UInt32 {
            switch self {
            case .String:
                return Value.stringFlag
            case .Data:
                return Value.dataFlag
            }
        }
        
        var raw: (value: UnsafePointer<Int8>, length: Int)? {
            switch self {
            case .String(let str):
                guard let str = str.cStringUsingEncoding(NSUTF8StringEncoding) else {
                    return nil
                }
                return (UnsafePointer(str), str.count)
            case .Data(let data):
                return (UnsafePointer(data.bytes), data.length)
            }
        }
    }
}

final public class Connection {
    
    private let _pool: ConnectionPool
    private let _mc: UnsafeMutablePointer<memcached_st>
    
    init(memcached: UnsafeMutablePointer<memcached_st>, pool: ConnectionPool) {
        _mc = memcached
        _pool = pool
    }
    
    deinit {
        _pool.pop(_mc)
    }
        
    public var ping: Bool {
        
        guard _mc != nil else { return false }
        
        let rc = memcached_version(_mc)
        return rc == MEMCACHED_SUCCESS
    }
    
    public func stringForKey(key: String) throws -> String? {
        
        switch try valueForKey(key) {
        case .String(let str)?:
            return str
        default:
            return nil
        }
    }
    
    public func dataForKey(key: String) throws -> NSData? {
        
        switch try valueForKey(key) {
        case .Data(let data)?:
            return data
        default:
            return nil
        }
    }
    
    private func valueForKey(key: String) throws -> Value? {
        
        var val_len: Int = 0
        var flags: UInt32 = 0
        var rc: memcached_return = MEMCACHED_MAXIMUM_RETURN
        let val = memcached_get(_mc, key, key.utf8.count, &val_len, &flags, &rc)
        defer {
            free(val)
        }
        
        if rc == MEMCACHED_NOTFOUND {
            return nil
        }
        
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
        
        if val == nil {
            return nil
        }
        
        if flags == Value.stringFlag {
            return String.fromCString(val).map(Value.String)
        }
        
        if flags == Value.dataFlag {
            return Value.Data(NSData(bytes: val, length: val_len))
        }
        return nil
    }
    
    public func set(value: String, forKey key: String, expire: Int = 0) throws {
        
        try set(Value.String(value), forKey: key, expire: expire)
    }
    
    public func set(value: NSData, forKey key: String, expire: Int = 0) throws {
       
        try set(Value.Data(value), forKey: key, expire: expire)
    }
    
    private func set(value: Value, forKey key: String, expire: Int = 0) throws {
        
        var rc: memcached_return = MEMCACHED_MAXIMUM_RETURN
        
        guard let raw = value.raw else {
            throw Connection.Error.ConvertError
        }
        
        rc = memcached_set(_mc, key, key.utf8.count, raw.value, raw.length, expire, value.flags)
        
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
    }
}
