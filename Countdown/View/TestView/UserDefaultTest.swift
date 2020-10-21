//
//  UserDefaultTest.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    
    // 这是一个 Published 属性，SwiftUI 可以监听该属性值的变化来自动更新视图
    @Published var username: String {
        // 定义 didSet 属性观察器，当该属性值发生变化后自动调用该函数
        didSet {
            // 将该属性值写入 UserDefaults.standard 的 username 键值对
            UserDefaults.standard.set(username, forKey: "username")
            log.debug("调用 didset: \(username)")
        }
    }
    
    init() {
        // 从 UserDefaults.standard 中读取 username 键值
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
    }
}

struct UserDefaultView: View {
    // 将该属性声明为 ObseredObject，这样当该属性发生变化时候会自动刷新视图
    @ObservedObject var userSettings = UserSettings()
    
    // 获取 UserDefaults 的存储路径
    let storagePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    
    var body: some View {
            VStack {
                TextField("Username", text: $userSettings.username)
                
                Text("UserDefaults 存储路径: \(storagePath)/Preferences/")
            }
            .padding(.all, 20.0)
    }
}
