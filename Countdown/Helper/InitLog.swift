//
//  InitLog.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import XCGLogger
import Foundation

// 定义一个全局的 log 对象
let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

func initLog() {
    
    // Create a destination for the system console log (via NSLog)
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
    // Optionally set some configuration options
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = false
    systemDestination.showThreadName = false
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    #if DEBUG
    systemDestination.outputLevel = .debug
    #else
    systemDestination.outputLevel = .error
    systemDestination.logQueue = XCGLogger.logQueue
    #endif

    
    var logDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/Logs"
    if !FileManager.default.directoryExists(logDirectory) {
        logDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    let logPath = logDirectory + "/\(Bundle.main.bundleIdentifier!).log"
    
    // Create a auto rotating file log destination
    let fileDestination = AutoRotatingFileDestination(writeToFile: logPath,
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
    fileDestination.outputLevel = .error
    #endif
    
    
    // Add the destination to the logger
    log.add(destination: systemDestination)
    log.add(destination: fileDestination)
}
