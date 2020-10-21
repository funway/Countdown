//
//  Preference.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation

// 先弄完 countdown events 再弄这个配置项吧 别急
class Preference: ObservableObject {
    
    @Published var isStartupWithOS: Bool {
        didSet {
            // 初次赋值不会触发 didSet
            log.debug("设置开机启动项: \(isStartupWithOS)")
            UserDefaults.standard.set(isStartupWithOS, forKey: "isStartupWithOS")
        }
    }
    
    init() {
        log.debug("Load preference from: \(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/Preferences/")
        self.isStartupWithOS = UserDefaults.standard.bool(forKey: "isStartupWithOS")
    }
}
