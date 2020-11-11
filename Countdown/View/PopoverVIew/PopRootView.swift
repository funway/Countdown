//
//  PopRootView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI


enum PopContainedViewType {
    case list
    case add
    case edit
    case detail
}


struct PopRootView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack{
            if .list == self.userData.currentPopContainedViewType {
                PopEventList().transition(.move(edge: .leading))
            }
                
            else if .edit == self.userData.currentPopContainedViewType {
                PopEventEdit(cdEvent: self.userData.currentClickedEvent).transition(.move(edge: .trailing))
            }
            
            else if .add == self.userData.currentPopContainedViewType {
                PopEventEdit().transition(.move(edge: .trailing))
            }
        
            #if DEBUG
            Divider()
            VStack {
                Button("Print Debug") {
                    log.verbose("Print Debug =========")
                    
                    for i in 0...self.userData.countdownEvents.count / 2 {
                        self.userData.countdownEvents[i].createAt = Date().adjust(hour: nil, minute: nil, second: 0)
                        self.userData.countdownEvents[i].endAt = Date().adjust(.minute, offset: 1).adjust(hour: nil, minute: nil, second: 0)
                    }
                    
                    let appDelegate = NSApplication.shared.delegate as! AppDelegate
                    log.debug("\(appDelegate.eventListController.tableView.hiddenRowIndexes)")
                    
                    log.debug(Locale.current)
                    log.debug(Locale.current.languageCode!)
                    
                    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                    let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
                    log.debug("version: \(version)")
                    log.debug("build: \(build)")

                    log.verbose("========= Print Debug")
                }  
                
            }.padding()
            #endif
            
        }.padding(.bottom, 20).frame(width: Theme.popViewWidth)
    }
    
    init() {
        log.verbose("初始化 PopRootView 视图")
    }
}

struct PopRootView_Previews: PreviewProvider {
    static var previews: some View {
        PopRootView().environmentObject(UserData.shared)
    }
}
