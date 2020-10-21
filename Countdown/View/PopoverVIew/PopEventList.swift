//
//  PopEventList.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PopEventList: View {
    @EnvironmentObject var userData: UserData
    
    let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    let settingsButton: some View = Button(action: {}) {
        Image("SettingsIcon")
            .resizable()
            .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
    }.buttonStyle(BorderlessButtonStyle())
    
    var body: some View {
        VStack(spacing: Theme.popViewSpacingV) {
            HStack() {
                
                // 这里 label 不直接用 Image 而要用 Button 包裹一下的原因是，为了保持与右边的按钮颜色一致
                MenuButton(label: settingsButton) {
                    Button("设置") {
                        log.verbose("点击设置菜单")
                    }
                    Toggle("随系统启动", isOn: $userData.preference.isStartupWithOS)
                    Button("退出") {
                        NSApplication.shared.terminate(self)
                    }
                }
                .frame(width: Theme.popViewHeaderIconWidth)
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                Text("Countdown").font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Button(action: {
                    log.verbose("点击添加按钮")
                    self.userData.currentEvent = nil
                    withAnimation {
                        self.userData.currentPopContainedViewType = PopContainedViewType.add
                    }
                }) {
                    Image("PlusIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
            }
            .padding(.vertical, Theme.popViewHeaderPaddingV)
            
            Divider()
            
            EventList().padding(.horizontal, Theme.popViewContentPaddingH)
        }
    }
    
    init() {
        log.verbose("初始化 PopEventList 视图")
    }
}

struct PopEventList_Previews: PreviewProvider {
    static var previews: some View {
        PopEventList()
            .frame(width: Theme.popViewWidth)
            .environmentObject(UserData())
    }
}
