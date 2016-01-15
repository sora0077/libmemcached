//
//  AppDelegate.swift
//  Demo
//
//  Created by 林達也 on 2016/01/11.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Cocoa
@testable import Memcached


struct Options: ConnectionOption {
    
    var host: String = "localhost"
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let conn = Connection(options: Options())
        
        print(conn.ping)
        
        try! conn.connect()
        
        do {
            if let val = try conn.stringForKey("value") {
                print(val)
            } else {
                try conn.set("日本語😬👨‍👩‍👧‍👧", forKey: "value", expire: 6)
                print("failure")
            }
        } catch {
            print(error)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

