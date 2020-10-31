//
//  AppTimer.swift
//  Countdown
//
//  Created by funway on 2020/10/31.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import Combine


/// 全局的计时器，每秒钟发布一次 ticktock
class AppTimer: ObservableObject {
    static let shared = AppTimer()
    private init() {}
    
    private var timer: AnyCancellable?
    
    /// 供订阅的发布者，每秒钟触发一次
    @Published var ticktock = Date()
    
    /// 启动计时器
    func start() {
        timer?.cancel()
        timer = Timer.publish(every: 1.0, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect().sink(receiveValue: { _ in
            log.verbose("AppTimer tick tock")
            self.ticktock = Date()
        })
    }
    
    
    /// 暂停计时器
    func stop() {
        timer?.cancel()
    }
}
