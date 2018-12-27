//
//  SwiftFile.swift
//  ASDF
//
//  Created by Macmafia on 2018/9/1.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

import Foundation

class SwiftFile : NSObject {
    @objc var name : String?
    @objc let nick : String
    
    @objc init(name:String,nick:String) {
        self.name = name
        self.nick = nick
        super.init()
    }
    
    @objc func swiftInstanceMethod(name:String) -> String {
        self.name = name
        if !name.isEmpty {
            print("name is:\(name)")
        }
        return name;
    }
    
    @objc class func swiftClassMethod(nick:String) -> String {
        print("nick is:\(nick)")
        var arr:Array<Int> = [Int]()
        arr.append(1)
        return nick
    }
}
