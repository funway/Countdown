//
//  SettingsView.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @State var launchAtLogin = false
    @ObservedObject var preference = Preference.shared
    
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                VStack {
                    Divider()
                }
                Text("通用").fontWeight(.light)
                VStack {
                    Divider()
                }
            }
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text("登录时启动:")
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$launchAtLogin, perform: { _ in
                            if !SMLoginItemSetEnabled(launchHelperBundleId as CFString, self.launchAtLogin) {
                                log.error("无法为 \(launchHelperBundleId) 设置启动项")
                            }
                        }).onAppear(){
                            let foundHelper = NSWorkspace.shared.runningApplications.contains(where: { element in
                                return element.bundleIdentifier == launchHelperBundleId
                            })
                            
                            self.launchAtLogin = foundHelper ? true : false
                        }
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: 21)
            
            Spacer().frame(height: 20)
            
            HStack {
                VStack {
                    Divider()
                }
                Text("新建倒计时").fontWeight(.light)
                VStack {
                    Divider()
                }
            }
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text("启用提醒:")
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$preference.remindMe, perform: { _ in
                        })
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: 21)
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text("桌面便签:")
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$preference.showStickyNote, perform: { _ in
                        })
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: 21)
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
