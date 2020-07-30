//
//  AppDelegate.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // 类型后面用 ! 号表示这是一个隐式解析的可选类型
    var statusBar: StatusBarController!
    var popover: NSPopover!

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = TestView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        // 上面这部分代码可以删除了
        
        
        // 初始化日志模块
        initLog()
        
        // 初始化 SQLite 数据库模块
        initSQLite()
        
        // 创建 NSPopover 类型实例
        popover = NSPopover()
        // 必须先为 NSPopover 设置视图控制器后才能添加视图
        popover.contentViewController = PopContentViewController()
        popover.contentSize = NSSize(width: 320, height: 320)
        // 这里用 ? 问号表示是一个可选链式调用。如果改用 ! 的话则表示强制解包，强制解包的链式调用遇到 nil 时会报错
        popover.contentViewController?.view = NSHostingView(rootView: PopContentView())
        
        // 创建状态栏图标控制器
        statusBar = StatusBarController(popover)
        
        #if DEBUG
            test()
        #endif
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

