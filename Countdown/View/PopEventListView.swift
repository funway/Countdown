//
//  PopEventListView.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PopEventListView: View {
    @Binding var currentPopContainedViewType: PopContainedViewType
    
    var body: some View {
        VStack(spacing: 2.0) {
            HStack() {
                Button(action: {
                    log.debug("点击设置按钮")
                }) {
                    Image("SettingsIcon")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                Text("Countdown")
                
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
            .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            Text("Hello, World!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Quit"){
                NSApplication.shared.terminate(self)
            }
        }
    }
}

struct PopEventListView_Previews: PreviewProvider {
    static var previews: some View {
        PopEventListView(currentPopContainedViewType: .constant(PopContainedViewType.list))
    }
}
