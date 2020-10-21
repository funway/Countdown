//
//  Helper.swift
//  Countdown
//
//  Created by funway on 2020/8/22.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import UserNotifications

class Helper {
    
    /// 不允许实例化
    private init() {
        
    }
    
    
    /// 获取一个 类类型实例 的内存地址
    /// - Parameter obj: a class object
    /// - Returns: 内存地址的字符串表示
    static func addressOf<T: AnyObject>(obj: T) -> String {
        return String(describing: Unmanaged.passUnretained(obj).toOpaque())
    }
    
    
    /// 获取一个 值类型实例 的内存地址
    /// - Parameter pointor: 指向值类型实例的指针，实参形式为: &var
    /// - Returns: 内存地址的字符串表示
    static func addressOf<T>(pointor: UnsafePointer<T>) -> String {
        return String(describing: pointor)
    }
    
    static func sendCountdownNotification(for cdEvent: CountdownEvent) {
        log.debug("发送倒计时结束的通知: \(cdEvent.title)")
        
        // 1. 创建一个“通知实体” UNMutableNotificationContent
        let content = UNMutableNotificationContent()
        content.title = cdEvent.title
        content.body = "倒计时结束！"
        content.sound = .default
        
        // 注意：
        //  如果程序当前处于活跃状态(foreground)，那么通知默认只出现在系统的“通知中心”，不会出现弹窗与声音。
        //  如果程序当前处于非活跃状态（background），那么通知会出现在系统的“通知中心” + 弹窗 + 声音。
        
        
        // 2. 创建一个 UNNotificationRequest 实例，代表一个“推送请求“
        // identifier 唯一标识该“推送请求”的字符串 ID。如果同一 ID 的“推送请求”还在等待推送，那就不会重复进入“等待推送的队伍”。
        // content 即上面创建的“通知实体”
        // trigger 即上面创建的“通知触发器”。trigger 可以设置为 nil，表示立即触发。
        let request = UNNotificationRequest(identifier: cdEvent.uuid.uuidString, content: content, trigger: nil)
        
        
        // 3. 将“推送请求”添加到系统的通知中心（第一次还需要向用户获取推送通知的权限）
        let notificationCenter = UNUserNotificationCenter.current()
        
        // 4. 将“推送请求”添加到系统的通知中心
        notificationCenter.add(request) { error in
            if error != nil {
                log.error("无法添加到系统通知中心: \(error!)")
            }
        }
    }
}
