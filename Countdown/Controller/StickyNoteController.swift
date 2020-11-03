//
//  StickyNoteController.swift
//  Countdown
//
//  Created by funway on 2020/8/25.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI


/// 该控制器控制所有以“便利贴”形式显示在桌面的倒计时视图
final class StickyNoteController {
    
    /// 获取 StickyNoteController 的单例
    static let shared = StickyNoteController()
    
    /// 要不要设置成私有呀？
    var stickyNotes = [UUID : StickyNoteWindow]()
    
    var stickyNoteCount:Int {
        return stickyNotes.count
    }
    
    /// 不允许实例化，只能通过 shared 属性获取单例
    private init() {}
    
    
    /// 添加一个 “便利贴” 视图
    /// - Parameter cdEvent: CountdownEvent 对象
    func add(for cdEvent: CountdownEvent) {
        
        if (self.stickyNotes[cdEvent.uuid] != nil) {
            log.warning("\(cdEvent) 的便利贴窗口已存在")
            
            self.stickyNotes[cdEvent.uuid]?.orderFront(nil)
        } else {

            let window = StickyNoteWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
                styleMask: [],
                backing: .buffered, defer: false)
            
            let contentView = StickyNoteView(cdEvent: cdEvent, window: window)
            
            window.setFrameAutosaveName("StickyNote | \(cdEvent.uuid.uuidString)")
            
            window.isMovableByWindowBackground = true
            
            if cdEvent.stickyNoteIsFloating {
                window.level = .floating
            }
            
            window.hasShadow = true
            
            window.contentView = NSHostingView(rootView: contentView)
            
            // 由 remove() 方法中手工释放窗口对象
            window.isReleasedWhenClosed = false
            
            window.orderFront(nil)
            
            self.stickyNotes[cdEvent.uuid] = window
        }
    }
    
    
    /// 删除一个 “便利贴” 视图
    /// - Parameter cdEvent: CountdownEvent 对象
    func remove(for cdEvent: CountdownEvent) {
        self.stickyNotes[cdEvent.uuid]?.close()
        self.stickyNotes.removeValue(forKey: cdEvent.uuid)
    }
}
