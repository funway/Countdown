//
//  PopEventAddView.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PopEventAddView: View {
    @Binding var currentPopContainedViewType: PopContainedViewType
    
    var body: some View {
        VStack(spacing: 2.0) {
            HStack() {
                Button(action: {
                    log.debug("点击后退按钮")
                    withAnimation {
                        self.currentPopContainedViewType = .list
                    }
                }) {
                    Image("LeftIcon")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                Text("Add")
                
                Spacer()
                
                Button(action: {
                    log.debug("点击保存按钮")
                    withAnimation {
                        self.currentPopContainedViewType = .list
                    }
                }) {
                    Image("SaveIcon")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
            }
            .padding(.vertical, 6.0)
            .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            
            
            Text("Hello, Add!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Quit"){
                NSApplication.shared.terminate(self)
            }
        }
    }
}

struct PopEventAddView_Previews: PreviewProvider {
    static var previews: some View {
        PopEventAddView(currentPopContainedViewType: .constant(PopContainedViewType.list))
    }
}
