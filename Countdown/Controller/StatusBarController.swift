//
//  StatusBarController.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import AppKit

class StatusBarController {
    private var statusItem: NSStatusItem
    private var statusBarButton: NSStatusBarButton
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: 30)
        self.statusBarButton = statusItem.button!
        self.popover = popover
        
        // 设置状态栏图标
        statusBarButton.image = NSImage(imageLiteralResourceName: "StatusBarIcon")
        statusBarButton.image!.size = NSSize(width: 18, height: 18)
        
        // 设置状态栏图标点击事件
        // #selector(func) 语法糖生成一个 Selector 实例，它对应 Object-C 的 SEL 类型，实际上就是“函数指针”
        statusBarButton.action = #selector(togglePopover(_:))
        statusBarButton.target = self
        
        // 定义一个外部事件监听器
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: outerClickedHandler)
    }
    
    // Swift 中的 @objc 特性表示表示这个声明可以被 Object-C 代码调用
    @objc func togglePopover(_ sender: AnyObject)
    {
        if popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        // relativeTo 参数表示 popover 关联视图的边界
        // of 参数表示 popover 要关联的视图
        // preferredEdge 参数表示 popover 的箭头要在关联视图的哪一边出现
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        
        // 启动外部事件监听
        eventMonitor?.start()
    }

    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        
        // 注销外部事件监听
        eventMonitor?.stop()
    }

    func outerClickedHandler(_ event: NSEvent?) {
        if(popover.isShown)
        {
            hidePopover(event!)
        }
    }
}
