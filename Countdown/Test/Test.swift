//
//  Test.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SQLite

/// 测试函数
func test() {
    print("\nTest Start")
    
//    var e1 = CountdownEvent(title: "明天开会")
//    log.debug(e1)
//    e1.save(at: db)
//    log.debug(e1)
//
//    e1.title = "不想开会啊😭"
//    e1.save(at: db)
    
    let table = Table(CountdownEvent.typeName)
    for row in try! db.prepare(table) {
        let event = CountdownEvent(row: row)
        log.debug("event: [\(event)]")
    }
    
    
    print("Test End\n")
}
