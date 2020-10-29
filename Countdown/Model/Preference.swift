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
        testString = UserDefaults.standard.string(forKey: keyForTestString) ?? "空空"
    }
    
    
    @Published var remindMe: Bool {
        didSet {
            log.debug("设置默认提醒: \(remindMe)")
            UserDefaults.standard.set(remindMe, forKey: keyForRemindMe)
        }
    }
    let keyForRemindMe = "Countdown | New Event | remindMe"
    
    
    @Published var showStickyNote: Bool {
        didSet {
            log.debug("设置默认显示便签: \(showStickyNote)")
            UserDefaults.standard.set(showStickyNote, forKey: keyForShowStickyNote)
        }
    }
    let keyForShowStickyNote = "Countdown | New Event | showStickyNote"
    
    
    @Published var testString: String {
        didSet {
            log.debug("设置测试字符串: \(testString)")
            UserDefaults.standard.set(testString, forKey: keyForTestString)
        }
    }
    let keyForTestString = "Countdown | Test | testString"
}
