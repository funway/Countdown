//
//  Theme.swift
//  Countdown
//
//  Created by funway on 2020/8/21.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI

/// 程序主题
struct Theme {
    /// 状态栏弹出框 宽度
    static let popViewWidth = CGFloat(340)
    
    /// 状态栏弹出框 子视图 垂直间隔
    static let popViewSpacingV = CGFloat(0)
    
    /// 状态栏弹出框 头部栏 高度
    static let popViewHeaderHeight = CGFloat(40)
    
    /// 状态栏弹出框 头部栏 垂直padding
    static let popViewHeaderPaddingV = CGFloat(8)
    
    /// 状态栏弹出框 头部栏 图标 宽度
    static let popViewHeaderIconWidth = CGFloat(24)
    
    /// 状态栏弹出框 头部栏 图标 高度
    static let popViewHeaderIconHeight = CGFloat(24)
    
    /// 状态栏弹出框 内容栏 水平padding
    static let popViewContentPaddingH = CGFloat(15)
    
    /// 状态栏弹出框 内容栏 垂直padding
    static let popViewContentPaddingV = CGFloat(15)
   
    /// 状态栏弹出框 内容栏 子视图 垂直间隔
    static let popViewContentSpacingV = CGFloat(7)
        
    /// 状态栏弹出框 内容栏 子视图 子Section 垂直间隔
    static let popViewContentSectionSpacingV = CGFloat(5)
    
    /// 状态栏弹出框 内容栏 图标 宽度
    static let popViewContentIconWidth = CGFloat(20)
    
    /// 状态栏弹出框 内容栏 图标 高度
    static let popViewContentIconHeight = CGFloat(20)
    
    /// 状态栏弹出框 倒计时列表 每行高度
    static let popViewEventRowHeight = CGFloat(50)
    
    static let colors = [NSColor(hex: 0xf4f1de), NSColor(hex: 0xf0f3bd), NSColor(hex: 0x81b29a),
                         NSColor(hex: 0x02c39a), NSColor(hex: 0x00a896), NSColor(hex: 0x028090),
                         NSColor(hex: 0x05668d), NSColor(hex: 0x264653), NSColor(hex: 0x3d405b),
                         NSColor(hex: 0xe07a5f), NSColor(hex: 0xf2cc8f), NSColor(hex: 0xe76f51),
                         NSColor(hex: 0xf4a261), NSColor(hex: 0xe9c46a)]
    
}
