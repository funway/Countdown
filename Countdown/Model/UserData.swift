//
//  UserData.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation

final class UserData: ObservableObject {
    
    /// 获取 UserData 的单例
    static let shared = UserData()
    
    /// 保存倒计时事件的数组
    @Published var countdownEvents: [CountdownEvent]
    
    /// 当前状态栏弹出框的视图类型（默认是列表视图）
    @Published var currentPopContainedViewType: PopContainedViewType = .list
    
    /// 当前点击的倒计时事件（在 popEventList 视图中点击）
    var currentClickedEvent: CountdownEvent?
    
    private init() {
        self.countdownEvents = loadCountdownEvent()
    }
}
