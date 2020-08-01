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


/// 全局的 log 对象
let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

/// 全局的 SQLite 数据库连接
var db: SQLite.Connection!

/// 全局的时间函数
var cdEvents: [CountdownEvent] = []
