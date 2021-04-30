//
//  PopEventList.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct PopEventList: View {
    @EnvironmentObject var userData: UserData
    
    let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    let settingsButton: some View = Button(action: {}) {
        Image("SettingsIcon")
            .resizable()
            .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
    }.buttonStyle(BorderlessButtonStyle())
    
    var body: some View {
        VStack(spacing: Theme.popViewSpacingV) {
            HStack() {
                
                if #available(macOS 11.0, *) {
                    // macOS 11 版本不支持 MenuButton 了，所以用 Menu 叠加 Image 来实现图标菜单
                    ZStack {
                        Image("SettingsIcon")
                            .resizable()
                            .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                        
                        Menu {
                            Button(NSLocalizedString("Preferences", comment: "")) {
                                PreferencesWindowController.shared.show()
                                
                                let appDelegate = NSApplication.shared.delegate as! AppDelegate
                                appDelegate.statusBarController.hidePopover(nil)
                            }
                            Button("Quit") {
                                NSApplication.shared.terminate(self)
                            }
                        } label: {
                        }
                        .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                        .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))
                    }.padding(.horizontal)
                } else {
                    // Fallback on earlier versions
                    MenuButton(label: settingsButton) {
                        // 这里 label 不直接用 Image 而要用 Button 包裹一下的原因是，为了保持与右边的按钮颜色一致
                        
                        Button(NSLocalizedString("Preferences", comment: "")) {
                            PreferencesWindowController.shared.show()
                            
                            let appDelegate = NSApplication.shared.delegate as! AppDelegate
                            appDelegate.statusBarController.hidePopover(nil)
                        }
                        Button("Quit") {
                            NSApplication.shared.terminate(self)
                        }
                    }
                    .frame(width: Theme.popViewHeaderIconWidth)
                    .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Text("Countdown").font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Button(action: {
                    log.verbose("点击添加按钮")
                    self.userData.currentClickedEvent = nil
                    withAnimation {
                        self.userData.currentPopContainedViewType = PopContainedViewType.add
                    }
                }) {
                    Image("PlusIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
            }
            .padding(.vertical, Theme.popViewHeaderPaddingV)
            
            Divider()
            
            EventList()
                .frame(height: listHeight)
                .padding(.horizontal, Theme.popViewContentPaddingH)
        }
    }
    
    init() {
        log.verbose("初始化 PopEventList 视图")
    }
    
    
    /// 计算列表的高度
    private var listHeight: CGFloat {
        get {
            let height = Theme.popViewEventRowHeight * CGFloat(userData.countdownEvents.count)
            let minHeight = CGFloat(200)
            let maxHeight = CGFloat(600)
            
            if height < minHeight {
                return minHeight
            } else if height > maxHeight {
                return maxHeight
            }
            
            return height
        }
    }
}

struct PopEventList_Previews: PreviewProvider {
    static var previews: some View {
        PopEventList()
            .frame(width: Theme.popViewWidth)
            .environmentObject(UserData.shared)
    }
}
