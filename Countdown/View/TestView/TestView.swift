//
//  TestView.swift
//  Countdown
//
//  Created by funway on 2020/7/29.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestView: View {
     @State var showView = false

       var body: some View {
           GeometryReader { proxy in
               ZStack {
                   if self.showView {
                       VStack {
                           Text("Settings View")
                           Button(action: {
                               withAnimation {
                                   self.showView.toggle()
                               }
                           }, label: {
                               Text("Back")
                           })
                        
                            Spacer()
                       }
                       .frame(width: proxy.size.width, height: proxy.size.height)
                       .background(Color.red)
                       .transition(.offset(x: 100))
                   } else {
                       VStack {
                           Text("Home View")
                           Button(action: {
                               withAnimation {
                                   self.showView.toggle()
                               }
                           }, label: {
                               Text("Settings")
                           })
                        
                            MenuButton(label: Image("SettingsIcon")) {
                                Button("aaa") {}
                                Button("bbb") {}
                                Divider()
                                Button("ccc") {}
                            }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
                            .toolTip("helloworld")
                           }
                           .frame(width: proxy.size.width, height: proxy.size.height)
                           .background(Color.green)
                   }
               }
           }
       }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
