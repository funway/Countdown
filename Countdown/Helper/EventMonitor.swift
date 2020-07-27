//
//  EventMonitor.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Cocoa

class EventMonitor {
    // 真正的监听器实例
    private var monitor: Any?
    
    // 要监听的事件类型
    private let mask: NSEvent.EventTypeMask
    
    // 监听到事件后调用的处理方法
    private let handler: (NSEvent?) -> Void
    
    // mask 是要监听的事件类型
    // handler 是事件处理函数，它是一个逃逸闭包，接受一个 NSEvent? 类型作为参数，返回 Void（无返回值）
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
      self.mask = mask
      self.handler = handler
    }

    deinit {
      stop()
    }

    // 向系统注册一个全局监听器，并返回给自己的 monitor 属性
    public func start() {
        // as! 表示将前面的可选类型当作 NSObject 进行强制解包
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
    }

    // 从系统中删除自身监听器，并销毁
    public func stop() {
      if monitor != nil {
        // 从系统全局事件监听器队列中删除自己的监听器
        NSEvent.removeMonitor(monitor!)
        
        // 解除引用，使得该事件监听器实例被销毁
        monitor = nil
      }
    }
}
