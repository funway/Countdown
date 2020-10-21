//
//  Initializer.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import XCGLogger
import SQLite


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


func initLog() {
    
    // Create a destination for the system console log (via NSLog)
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
    // Optionally set some configuration options
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = false
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    #if DEBUG
    systemDestination.outputLevel = .verbose
    #else
    systemDestination.outputLevel = .error
    systemDestination.logQueue = XCGLogger.logQueue
    #endif

    
    var logDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/Logs"
    if !FileManager.default.directoryExists(logDirectory) {
        logDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    let logFile = logDirectory + "/\(Bundle.main.bundleIdentifier!).log"
    
    // Create a auto rotating file log destination
    let fileDestination = AutoRotatingFileDestination(writeToFile: logFile,
                            identifier: "advancedLogger.fileDestination",
                            shouldAppend: true, appendMarker: "-- Relauched App --",
                            maxFileSize: 10485760, maxTimeInterval: 0, targetMaxLogFiles: 3)
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = true
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true
    fileDestination.showDate = true
    // 设置 fileDestination 为异步输出日志
    fileDestination.logQueue = XCGLogger.logQueue
    #if DEBUG
    fileDestination.outputLevel = .debug
    #else
    fileDestination.outputLevel = .warning
    #endif
    
    
    // Add the destination to the logger
    log.add(destination: systemDestination)
    log.add(destination: fileDestination)
    
    
    // You can also change the labels for each log level, most useful for alternate languages, French, German etc, but Emoji's are more fun
    log.levelDescriptions[.verbose] = "🗯 Verbose"
    log.levelDescriptions[.debug] = "✏️ Debug"
    log.levelDescriptions[.info] = "ℹ️ Info"
    log.levelDescriptions[.notice] = "✳️ Notice"
    log.levelDescriptions[.warning] = "⚠️ Warning"
    log.levelDescriptions[.error] = "‼️ Error"
    log.levelDescriptions[.severe] = "💣 Severe"
    log.levelDescriptions[.alert] = "🛑 Alert"
    log.levelDescriptions[.emergency] = "🚨 Emergency"
    
    // Alternatively, you can use emoji to highlight log levels (you probably just want to use one of these methods at a time).
    //    let emojiLogFormatter = PrePostFixLogFormatter()
    //    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    //    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    //    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    //    emojiLogFormatter.apply(prefix: "✳️✳️✳️ ", postfix: " ✳️✳️✳️", to: .notice)
    //    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    //    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    //    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    //    emojiLogFormatter.apply(prefix: "🛑🛑🛑 ", postfix: " 🛑🛑🛑", to: .alert)
    //    emojiLogFormatter.apply(prefix: "🚨🚨🚨 ", postfix: " 🚨🚨🚨", to: .emergency)
    //    log.formatters = [emojiLogFormatter]
    
    // Test log
    //    log.verbose("A verbose message, usually useful when working on a specific problem")
    //    log.debug("A debug message")
    //    log.info("An info message, probably useful to power users looking in console.app")
    //    log.notice("A notice message")
    //    log.warning("A warning message, may indicate a possible error")
    //    log.error("An error occurred, but it's recoverable, just info about what happened")
    //    log.severe("A severe error occurred, we are likely about to crash now")
    //    log.alert("An alert error occurred, a log destination could be made to email someone")
    //    log.emergency("An emergency error occurred, a log destination could be made to text someone")
}


/// 从 SQLite 数据库中读取 CountdownEvent 数据
/// - Parameter excludeSoftDelete: 是否排除软删除的数据，默认为 true
/// - Returns: 返回 CountdownEvent 对象数组
func loadCountdownEvent(excludeSoftDelete: Bool = true) -> [CountdownEvent] {
    log.debug("Load CountdownEvent data from SQLite")
    
    var cdEvents: [CountdownEvent] = []
    var table = Table(CountdownEvent.typeName)
    
    // 设置查询条件
    if excludeSoftDelete {
        table = table.filter(CountdownEvent.deleteAt == nil)
    }
    table = table.order(CountdownEvent.listOrder.asc, CountdownEvent.createAt.desc)
    
    for row in try! db.prepare(table) {
        let cdEvent = CountdownEvent(row: row)
        cdEvents.append(cdEvent)
    }
    
    return cdEvents
}


/// Load user preference from UserDefaults
func loadPreference() {
    log.debug("Load user preference from UserDefaults")
}
