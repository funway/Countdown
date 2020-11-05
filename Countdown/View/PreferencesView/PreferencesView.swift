//
//  PreferencesView.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
    private let tabItemsName = [NSLocalizedString("Settings", comment: ""), NSLocalizedString("About", comment: "")]
    @State private var selectedTabIndex = 0
    
    let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    var body: some View {
        VStack(spacing: 0.0) {
            
            SegmentedPicker(labels: tabItemsName, selectedIndex: $selectedTabIndex).padding()
            
            if (selectedTabIndex == 0) {
                SettingsView()
                    .frame(height: 230)
                    .padding(.horizontal)
            } else if (selectedTabIndex == 1) {
                AboutView()
                    .frame(height: 320)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }.frame(width: 350)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
