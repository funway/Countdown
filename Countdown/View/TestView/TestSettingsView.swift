//
//  TestSettingsView.swift
//  Countdown
//
//  Created by funway on 2020/10/21.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

//extension NSSegmentedControl {
//    open override func updateLayer() {
//        self.segmentDistribution = .fillEqually
//        super.updateLayer()
//    }
//}



struct TestSettingsView: View {
    var tabItemsName = ["⚙️ Settings", "😃 About"]
    @State private var selectedTabIndex = 0
    
    var body: some View {
        VStack {
            
            SegmentedPicker(labels: tabItemsName, selectedIndex: $selectedTabIndex).padding()
            
            if (selectedTabIndex == 0) {
                SettingsView().frame(height: 250)
            } else if (selectedTabIndex == 1) {
                AboutView().frame(height: 330)
            }
        }.frame(width: 350)
    }
}

struct TestSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TestSettingsView()
//        AboutView()
//        SettingsView()
    }
}
