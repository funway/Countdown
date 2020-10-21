//
//  TestNotification.swift
//  Countdown
//
//  Created by funway on 2020/10/3.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import UserNotifications

struct TestNotification: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            Button("推送通知"){
                log.debug("click!")
                
                // 1. 创建一个“通知实体” UNMutableNotificationContent
                let content = UNMutableNotificationContent()
                content.title = "Weekly Staff Meeting"
                content.body = "Every Tuesday at 2pm"
                content.sound = .default
                
                // 注意：
                //  如果程序当前处于活跃状态(foreground)，那么通知默认只出现在系统的“通知中心”，不会出现弹窗与声音。
                //  如果程序当前处于非活跃状态（background），那么通知会出现在系统的“通知中心” + 弹窗 + 声音。
                
                
                // 2. 创建一个“通知触发器”
                // UNCalendarNotificationTrigger        用来指定在特定的时间点触发消息推送
                // UNTimeIntervalNotificationTrigger    用来指定在特定的时间间隔触发消息推送
                // UNLocationNotificationTrigger        用来指定当设备 进入/离开 特定的地理位置时候触发消息推送
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)


                // 3. 创建一个 UNNotificationRequest 实例，代表一个“推送请求“
                // identifier 唯一标识该“推送请求”的字符串 ID。如果同一 ID 的“推送请求”还在等待推送，那就不会重复进入“等待推送的队伍”。
                // content 即上面创建的“通知实体”
                // trigger 即上面创建的“通知触发器”。trigger 可以设置为 nil，表示立即触发。
                let request = UNNotificationRequest(identifier: "notification test", content: content, trigger: trigger)
                
                
                // 4. 将“推送请求”添加到系统的通知中心（第一次还需要向用户获取推送通知的权限）
                let notificationCenter = UNUserNotificationCenter.current()
                
                // 弹出对话框，向用户请求推送通知的权限（如果已授权，则不会重复弹窗）
                // 如果用户拒绝的话，那么后续 add 到通知中心的“推送请求”都会被忽略。
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    // 这是一个逃逸闭包
                }
                
                // 将“推送请求”添加到系统的通知中心
                notificationCenter.add(request) { error in
                    if error != nil {
                        log.error("无法添加到系统通知中心: \(error!)")
                    }
                }
            }
        }.frame(width: 300, height: 200)
        
    }
}

struct TestNotification_Previews: PreviewProvider {
    static var previews: some View {
        TestNotification()
    }
}
