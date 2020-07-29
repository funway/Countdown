//
//  InitSQLite.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SQLite


/// 全局的 SQLite 数据库连接
var db: SQLite.Connection!


func initSQLite() {
    let dbPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                    .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
    // 创建目录，如果该目录不存在的话
    try! FileManager.default.createDirectory(atPath: dbPath, withIntermediateDirectories: true)
    
    // 连接数据库（如果不存在数据库文件则自动创建）
    db = try! Connection("\(dbPath)/db.sqlite")
    
    #if DEBUG
    db.trace { log.verbose("Execute SQL: \($0)") }
    #endif
    
    // 创建 CountdownEvent 的数据库表结构，如果不存在的话
    try! CountdownEvent.createTable(at: db)
    
}
