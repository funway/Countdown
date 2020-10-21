//
//  TestNewWindow.swift
//  Countdown
//
//  Created by funway on 2020/8/2.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

var windowDic = [UUID: MyWindow]()
var panelDic = [UUID: PanelView]()

struct TestNewWindow: View {

    var body: some View {
        VStack {
            Text("新窗口测试").font(.title)
            Divider()
            
            Button("打开新窗口") {
                
            }
            
            Divider()
            
            Button("打开新 pannel") {
                let uuid = UUID()
                panelDic[uuid] = PanelView(uuid)
                log.verbose("地址：\(Helper.addressOf(pointor: &panelDic[uuid]))")
            }
            
        }.frame(width: 300, height: 300)
    }
}


class MyWindow: NSWindow {
    deinit {
        log.verbose("释放 MyWindow")
    }
}

class MyPanel: NSPanel {
    deinit {
        log.verbose("释放 MyPanel")
    }
}

struct PanelView: View {
    
    var panel: MyPanel!
    var uuid: UUID
    
    @State var hovered: Bool = false
    
    init(_ uuid: UUID) {
        self.uuid = uuid
        
        panel = MyPanel(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 200),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        panel.contentView = NSHostingView(rootView: self)
        panel.hidesOnDeactivate = false
        
        // 是否漂浮在顶层
        panel.isFloatingPanel = true
        
        panel.isReleasedWhenClosed = true
        panel.orderFront(nil)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle().frame(height: 30).foregroundColor(Color.clear)
                
                HStack() {
                    Spacer()
                    
                    if (hovered) {
                        Button(action: {
                            log.debug("点击关闭按钮")
                            log.verbose("地址1：\(Helper.addressOf(pointor: &panelDic[self.uuid]))")
                            panelDic[self.uuid] = nil
                            
                        }) {
                            Image("CloseIcon")
                            .resizable()
                            .frame(width: 18, height: 18)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Text("Hello, Panel")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.onHover(perform: { hovered in
            self.hovered = hovered
        })
    }
    
}
