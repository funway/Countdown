//
//  TestCustomedTabView.swift
//  Countdown
//
//  Created by funway on 2020/10/23.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestCustomedTabView: View {
    var body: some View {
        CustomTabView(
            tabBarPosition: .top,
            content: [
                (
                    tabText: "Tab 1",
                    tabIconName: "SettingsIcon",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("First Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.blue)
                    )
                ),
                (
                    tabText: "Tab 2",
                    tabIconName: "TrashIcon",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Second Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.red)
                    )
                ),
                (
                    tabText: "Tab 3",
                    tabIconName: "LeftIcon",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Third Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.yellow)
                    )
                )
            ]
        )
    }
}

struct TestCustomedTabView_Previews: PreviewProvider {
    static var previews: some View {
        TestCustomedTabView()
    }
}

public struct CustomTabView: View {
    
    public enum TabBarPosition { // Where the tab bar will be located within the view
        case top
        case bottom
    }
    
    private let tabBarPosition: TabBarPosition
    private let tabText: [String]
    private let tabIconNames: [String]
    private let tabViews: [AnyView]
    
    @State private var selection = 0
    
    public init(tabBarPosition: TabBarPosition, content: [(tabText: String, tabIconName: String, view: AnyView)]) {
        self.tabBarPosition = tabBarPosition
        self.tabText = content.map{ $0.tabText }
        self.tabIconNames = content.map{ $0.tabIconName }
        self.tabViews = content.map{ $0.view }
    }
    
    public var tabBar: some View {
        
        HStack {
            Spacer()
            ForEach(0..<tabText.count) { index in
                HStack {
                    Image(self.tabIconNames[index])
                    Text(self.tabText[index])
                }
                .padding()
                .foregroundColor(self.selection == index ? Color.accentColor : Color.primary)
                .onTapGesture {
                    self.selection = index
                }
            }
            Spacer()
        }
        .padding(0)
        .shadow(color: Color.clear, radius: 0, x: 0, y: 0)
        .shadow(
            color: Color.black.opacity(0.25),
            radius: 3,
            x: 0,
            y: tabBarPosition == .top ? 1 : -1
        )
        .zIndex(99) // Raised so that shadow is visible above view backgrounds
    }
    public var body: some View {
        
        VStack(spacing: 0) {
            
            if (self.tabBarPosition == .top) {
                tabBar
            }
            
            tabViews[selection]
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if (self.tabBarPosition == .bottom) {
                tabBar
            }
        }
        .padding(0)
    }
}
