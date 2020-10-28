//
//  TestTabView.swift
//  Countdown
//
//  Created by funway on 2020/10/23.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestTabView: View {
    private let tabs = ["Watch Now", "Movies", "TV Shows", "Kids", "Library"]
    @State private var selectedTab = 0
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker("", selection: $selectedTab) {
                    ForEach(tabs.indices) { i in
                        Text(self.tabs[i]).tag(i)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 8)
                Spacer()
            }
            .padding(.horizontal, 100)
            Divider()
            GeometryReader { gp in
                VStack {
                    ChildTabView(title: self.tabs[self.selectedTab], index: self.selectedTab)
                }
            }
        }
    }
}

struct ChildTabView: View {
    var title: String
    var index: Int

    var body: some View {
        Text("\(title)")
    }
}

struct TestTabView_Previews: PreviewProvider {
    static var previews: some View {
        TestTabView()
    }
}
