//
//  main.swift
//  libmemcached-demo
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import libmemcached

let memc = memcached_create(nil)
let servers = memcached_servers_parse("localhost:11211")
var rc = memcached_server_push(memc, servers)
if rc == MEMCACHED_SUCCESS {
    print("added server successfully")
} else {
    perror(String.fromCString(memcached_strerror(memc, rc)) ?? "")
}
memcached_server_list_free(servers)

var flags: UInt32 = 0
var val_len: Int = 3
let val = memcached_get(memc, "key", "key".utf8.count, &val_len, &flags, &rc)
if rc == MEMCACHED_SUCCESS {
    print(String.fromCString(val))
    free(val)
} else {
    print("error")
}
rc = memcached_set(memc, "key", "key".utf8.count, "value", "value".utf8.count, 0, 0)

if rc == MEMCACHED_SUCCESS {
    print("key stored successfully")
} else {
    perror(String.fromCString(memcached_strerror(memc, rc)) ?? "")
}

memcached_free(memc)
