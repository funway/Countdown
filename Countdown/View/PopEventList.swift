//
//  PopEventList.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PopEventList: View {
    @Binding var currentPopContainedViewType: PopContainedViewType
    @State var isStartupWithSystem: Bool = false
    
    let settingsButton: some View = Button(action: {}) { Image("SettingsIcon") }.buttonStyle(BorderlessButtonStyle())
    
    var body: some View {
        VStack(spacing: 2.0) {
            HStack() {
                MenuButton(label: settingsButton) {
                    Button("设置") {
                        log.debug("点击设置菜单")
                    }
                    Toggle("随系统启动", isOn: $isStartupWithSystem)
                    Button("退出") {
                        NSApplication.shared.terminate(self)
                    }
                }
                .frame(width: 24.0)
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                Text("Countdown").font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Button(action: {
                    log.debug("点击添加按钮")
                    withAnimation {
                        self.currentPopContainedViewType = .add
                    }
                }) {
                    Image("PlusIcon")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
            }
            .padding(.vertical, 6.0)
            
            Divider()
            
            ForEach(cdEvents, id: \.uuid) { cdEvent in
                VStack(spacing: 1.0){
                    EventRow(cdEvent: cdEvent)
                    Divider()
                }
            }.padding(.horizontal, 15.0)
        }
    }
}

struct PopEventList_Previews: PreviewProvider {
    static var previews: some View {
        PopEventList(currentPopContainedViewType: .constant(PopContainedViewType.list))
    }
}
