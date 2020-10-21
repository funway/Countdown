//
//  UserData.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation

final class UserData: ObservableObject {
    
    /// 当前状态栏弹出框的视图类型（默认是列表视图）
    @Published var currentPopContainedViewType: PopContainedViewType = .list
    
    @Published var countdownEvents: [CountdownEvent]
    
    @Published var preference: Preference
    
    var currentEvent: CountdownEvent?
    
    /// 构造器
    /// - Parameters:
    ///   - countdownEvents: CountdownEvent 对象数组，默认从 SQLite 数据库中读取（注意：数组是值类型）
    ///   - preference: Preference 对象，默认新建一个 Preference 对象
    init(countdownEvents: [CountdownEvent] = loadCountdownEvent(), preference: Preference = Preference()) {
        self.countdownEvents = countdownEvents
        self.preference = preference
    }
}
