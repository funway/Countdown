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
    private let rowHeight = CGFloat(25)
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack {
                    Divider()
                }
                Text(NSLocalizedString("Settings.General", comment: "")).fontWeight(.light)
                VStack {
                    Divider()
                }
            }
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text(NSLocalizedString("Settings.Launch at login", comment: ""))
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
            }.frame(height: rowHeight)
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text(NSLocalizedString("Settings.Display 24 hour", comment: ""))
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$preference.display24hour, perform: { _ in
                        })
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: rowHeight)
            
            Spacer().frame(height: 10)
            
            HStack {
                VStack {
                    Divider()
                }
                Text(NSLocalizedString("Settings.New Countdown", comment: "")).fontWeight(.light)
                VStack {
                    Divider()
                }
            }
            
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text(NSLocalizedString("Settings.Remind me", comment: ""))
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$preference.remindMe, perform: { _ in
                        })
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: rowHeight)
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Text(NSLocalizedString("Settings.Sticky note", comment: ""))
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .trailing)
                    
                    VStack {
                        PerformableSwitch(isOn: self.$preference.showStickyNote, perform: { _ in
                        })
                    }.frame(width: geometry.size.width/2, height: nil, alignment: .leading)
                }
            }.frame(height: rowHeight)
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
