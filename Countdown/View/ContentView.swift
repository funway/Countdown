//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import ServiceManagement

struct ContentView: View {
    @State var showAlert = false
    @State var date = Date()
    @State var launchAtLogin = false
    
    let helperBundleName = "me.hawu.LaunchHelper"

    var body: some View {
        VStack {
            Text("test")
            
            Button("alert") {
                log.debug("点击 alert 按钮")
                self.showAlert.toggle()
            }
            
            HStack {
                Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100, alignment: .center)
                
                Spacer()
                
                Text("你好啊 \(date)")
                
                Spacer()
                
                Button("time?") {
                    self.date = Date()
                }
            }
            .frame(width: 500, height: 200)
            .padding()
            .background(Color.yellow.opacity(0.3))
            .overlyingAlert(showAlert: $showAlert, title: "Alert!", message: "要删除吗？",
                confirmButton: Button("Ok") {
                    log.debug("alert 确认")
                    self.showAlert = false
                },
                cancelButton: Button("Cancel") {
                    log.debug("alert 取消")
                    self.showAlert = false
                }
            )
            
            HStack {
                Text("开机启动: ")
                
                PerformableSwitch(isOn: $launchAtLogin, perform: { _ in
                    SMLoginItemSetEnabled(self.helperBundleName as CFString, self.launchAtLogin)
                }).onAppear(){
                    let foundHelper = NSWorkspace.shared.runningApplications.contains {
                        $0.bundleIdentifier == self.helperBundleName
                    }
                    
                    self.launchAtLogin = foundHelper ? true : false
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
