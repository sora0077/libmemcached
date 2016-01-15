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
        case ConnectionError(String)
    }
    
    public enum Value {
        case String(Swift.String)
        case Data(NSData)
    }
}

final public class Connection {
    
    let _options: ConnectionOption
//    let _pool: ConnectionPool
    
    var _mc: UnsafeMutablePointer<memcached_st> = nil
    
    init(options: ConnectionOption) {
        _options = options
//        _pool = pool
    }
    
    deinit {
        dispose()
    }
    
    func dispose() {
        if _mc != nil {
            memcached_free(_mc)
        }
    }
    
    func connect() throws {
        
        dispose()
        
        _mc = memcached_create(nil)
        
        var rc: memcached_return = MEMCACHED_MAXIMUM_RETURN
        let servers = memcached_server_list_append(nil, _options.host, _options.port, &rc)
        defer {
            memcached_server_list_free(servers)
        }
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
        
        rc = memcached_server_push(_mc, servers)
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
        
    }
    
    var ping: Bool {
        
        guard _mc != nil else { return false }
        
        let rc = memcached_version(_mc)
        return rc == MEMCACHED_SUCCESS
    }
    
    func bytesForKey(key: String) throws -> [Int8]? {
        
        guard let data = try dataForKey(key) else { return nil }
        var buf: [Int8] = [Int8](count: data.length, repeatedValue: 0)
        data.getBytes(&buf, length: data.length)
        return buf
    }
    
    func stringForKey(key: String) throws -> String? {
        
        guard let data = try dataForKey(key) else { return nil }
        return String(data: data, encoding: NSUTF8StringEncoding)
    }
    
    func dataForKey(key: String) throws -> NSData? {
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
        
        return NSData(bytes: val, length: val_len)
    }
    
    func set(value: String, forKey key: String, expire: Int = 0) throws {
        
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding) {
            try set(data, forKey: key, expire: expire)
        }
    }
    
    func set(value: NSData, forKey key: String, expire: Int = 0) throws {
       
        var rc: memcached_return = MEMCACHED_MAXIMUM_RETURN
        rc = memcached_set(_mc, key, key.utf8.count, UnsafePointer(value.bytes), value.length, expire, 0)
        
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
    }
    
    func set(value: [Int8], forKey key: String, expire: Int = 0) throws {
        
        var rc: memcached_return = MEMCACHED_MAXIMUM_RETURN
        rc = memcached_set(_mc, key, key.utf8.count, value, value.count, expire, 0)
        
        if rc != MEMCACHED_SUCCESS {
            throw Connection.Error.ConnectionError(String.fromCString(memcached_strerror(_mc, rc)) ?? "")
        }
    }
}
