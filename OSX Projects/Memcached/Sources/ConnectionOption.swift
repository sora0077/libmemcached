//
//  ConnectionOption.swift
//  Memcached
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol ConnectionOption {

    var host: String { get }
    var port: UInt16 { get }
    
}

public extension ConnectionOption {
    
    var port: UInt16 {
        return 11211
    }
}
