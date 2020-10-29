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
//            Divider()
//            Button("Print Debug") {
//                log.verbose("Print Debug =========")
//                self.userData.countdownEvents[0].createAt = Date().adjust(.second, offset: -10)
//
//                self.userData.countdownEvents[0].endAt = Date().adjust(.second, offset: 30)
//
//                log.verbose("========= Print Debug")
//            }.padding()
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
