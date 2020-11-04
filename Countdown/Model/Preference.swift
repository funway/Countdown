//
//  Preference.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation


/// 单例模式
class Preference: ObservableObject {
    
    /// 获取 Preference 的单例
    static let shared = Preference()
    
    private init() {
        log.debug("Load preference from: \(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/Preferences/")
        
        remindMe = UserDefaults.standard.bool(forKey: keyForRemindMe)
        showStickyNote = UserDefaults.standard.bool(forKey: keyForShowStickyNote)
        display24hour = UserDefaults.standard.bool(forKey: keyForDisplay24hour)
        lastRestore = UserDefaults.standard.double(forKey: keyForLastRestore)
        testString = UserDefaults.standard.string(forKey: keyForTestString) ?? "空空"
        
        // 如果程序是第一次启动，还没有首选项时,lastRestore 值应该为0.0
        if lastRestore <= 0 {
            log.debug("不存在首选项 preference，使用默认值")
            restoreDefault()
        }
    }
    
    
    /// 新建倒计时事件，是否默认到期提醒
    @Published var remindMe: Bool {
        didSet {
            log.debug("设置默认提醒: \(remindMe)")
            UserDefaults.standard.set(remindMe, forKey: keyForRemindMe)
        }
    }
    let keyForRemindMe = "Countdown | New Event | remindMe"
    
    
    /// 新建倒计时事件，是否默认显示桌面便签
    @Published var showStickyNote: Bool {
        didSet {
            log.debug("设置默认显示便签: \(showStickyNote)")
            UserDefaults.standard.set(showStickyNote, forKey: keyForShowStickyNote)
        }
    }
    let keyForShowStickyNote = "Countdown | New Event | showStickyNote"
    
    @Published var display24hour: Bool {
        didSet {
            log.debug("设置时间显示为24小时制")
            UserDefaults.standard.set(display24hour, forKey: keyForDisplay24hour)
        }
    }
    let keyForDisplay24hour = "Countdown | Display | 24hour"
    
    private var lastRestore: Double {
        didSet {
            UserDefaults.standard.set(lastRestore, forKey: keyForLastRestore)
        }
    }
    private let keyForLastRestore = "Countdown | General | lastRestore"
    
    
    /// 将配置还原回默认值
    func restoreDefault() {
        remindMe = true
        showStickyNote = true
        display24hour = true
        
        lastRestore = Date().timeIntervalSince1970
    }
    
    
    @Published var testString: String {
        didSet {
            log.debug("设置测试字符串: \(testString)")
            UserDefaults.standard.set(testString, forKey: keyForTestString)
        }
    }
    let keyForTestString = "Countdown | Test | testString"
}
