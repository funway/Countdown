//
//  Global.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import XCGLogger
import SQLite

let _appVerion = "1.1.4"
#if DEBUG
let appVersion = _appVerion + " (Debug)"
#else
let appVersion = _appVerion
#endif

let launchHelperBundleId = "me.hawu.Countdown.LaunchHelper"

/// 全局的 log 对象
let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

/// 全局的 SQLite 数据库连接
var db: SQLite.Connection!


/// 当前 App 所用到的 SQLite 数据库表结构的版本号（ PRAGMA user_version; ）
/// 根据该版本号对数据库的表结构进行升级
let dbVersion: Int32 = 1
