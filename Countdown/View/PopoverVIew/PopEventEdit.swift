//
//  PopEventEdit.swift
//  Countdown
//
//  Created by funway on 2020/10/4.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import UserNotifications

struct PopEventEdit: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var cdEvent: CountdownEvent
    
    @State private var calenderBtnClicked = false
    @State private var clockBtnClicked = false
    @State private var showDeleteAlert = false
    @State private var showColorPalette = false
    
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    init(cdEvent: CountdownEvent? = nil) {
        log.verbose("初始化 PopEventEdit 视图")
        
        self.cdEvent = cdEvent ?? CountdownEvent(title: NSLocalizedString("Edit.Untitled", comment: ""),
                                                 endAt: Date().dateFor(.tomorrow).adjust(hour: 9, minute: 0, second: 0),
                                                 color: Theme.colors[Int.random(in: 0..<Theme.colors.count)],
                                                 remindMe: Preference.shared.remindMe,
                                                 showStickyNote: Preference.shared.showStickyNote)
    }
    
    var body: some View {
        VStack(spacing: Theme.popViewSpacingV) {
            
            // 头部栏
            HStack() {
                // 保存按钮
                Button(action: {
                    log.verbose("点击后退按钮")
                    
                    // 将 cdEvent 写入数据库
                    self.cdEvent.save(at: db)
                    
                    // 如果是新增的倒计时事件
                    if self.userData.currentPopContainedViewType == PopContainedViewType.add {
                        // 将 cdEvent 写入全局的 [CountdownEvent] 数组
                        self.userData.countdownEvents.insert(self.cdEvent, at: 0)
                        
                        // 在 EventListNSTableController 的 NSTableView 中新增一行
                        let appDelegate = NSApplication.shared.delegate as! AppDelegate
                        appDelegate.eventListController.insertRow(at: 0)
                    }
                    
                    // 返回列表视图
                    withAnimation {
                        self.userData.currentPopContainedViewType = .list
                    }
                }) {
                    Image("BackIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                    .toolTip(NSLocalizedString("Edit.Save & Back", comment: ""))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                if PopContainedViewType.add == userData.currentPopContainedViewType {
                    Text(NSLocalizedString("Add", comment: "")).font(.headline)
                } else if PopContainedViewType.edit == userData.currentPopContainedViewType {
                    Text(NSLocalizedString("Edit", comment: "")).font(.headline)
                }
                
                Spacer()
                
                // 删除按钮
                Button(action: {
                    log.verbose("点击删除按钮")
                    
                    if PopContainedViewType.add == self.userData.currentPopContainedViewType {
                        // 如果是在“新增”页面，直接删除
                        self.deleteCountdownEvent()
                    } else {
                        // 如果是在“编辑”页面，先弹出“确认删除”的提示
                        self.showDeleteAlert.toggle()
                    }
                }) {
                    Image("TrashIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                    .toolTip(NSLocalizedString("Delete", comment: ""))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
            }
            .padding(.vertical, Theme.popViewHeaderPaddingV)
            
            Divider()
            
            // 内容栏
            VStack(spacing: Theme.popViewContentSpacingV) {
                
                // 标题 section
                VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                    Text(NSLocalizedString("Edit.Title", comment: ""))
                        .font(.caption)
                    
                    TextField("Untitled", text: $cdEvent.title)
                        .font(.title)
                        .textFieldStyle(PlainTextFieldStyle())
                    Divider()
                }
                
                // 时间 section
                VStack(spacing: Theme.popViewContentSectionSpacingV) {
                    GeometryReader { geometry in
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                                Text(NSLocalizedString("Edit.Date", comment: ""))
                                    .font(.caption)
                                
                                HStack() {
                                    Button(action: {
                                        self.calenderBtnClicked.toggle()
                                    }) {
                                        Image("CalendarIcon")
                                            .resizable()
                                            .frame(width: Theme.popViewContentIconWidth, height: Theme.popViewContentIconHeight)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .popover(isPresented: self.$calenderBtnClicked, content: {
                                        DatePicker(selection: self.$cdEvent.endAt,
                                                   displayedComponents: [.date],
                                                   label: { Text("Date") })
                                            .datePickerStyle(GraphicalDatePickerStyle())
                                            .labelsHidden()
                                            .padding()
                                    })
                                    
                                    CustomNSDatePicker(date: self.$cdEvent.endAt, elements: .yearMonthDay, locale: Locale(identifier: "en_CN")).frame(width: 95)
                                    Spacer()
                                }
                            }.frame(width: geometry.size.width/2)
                            
                            VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                                Text(NSLocalizedString("Edit.Time", comment: "")).font(.caption)
                                
                                HStack {
                                    Button(action: {
                                        self.clockBtnClicked.toggle()
                                    }) {
                                        Image("ClockIcon")
                                        .resizable()
                                        .frame(width: Theme.popViewContentIconWidth, height: Theme.popViewContentIconHeight)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .popover(isPresented: self.$clockBtnClicked, content: {
                                        
                                        DatePicker(selection: self.$cdEvent.endAt,
                                                   displayedComponents: [.hourAndMinute],
                                                   label: { Text("Time") })
                                            .datePickerStyle(GraphicalDatePickerStyle())
                                            .labelsHidden()
                                            .padding()
                                    })
                                    
                                    CustomNSDatePicker(date: self.$cdEvent.endAt, elements: .hourMinute, locale: Locale(identifier: "en_GB")).frame(width: 60)
                                    Spacer()
                                }
                            }.frame(width: geometry.size.width/2)
                        }.frame(width: geometry.size.width)
                    }.frame(height: 40)
                    
                    Divider()
                }
                
                // 勾选项 section
                VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                    HStack {
                        Text(NSLocalizedString("Edit.Remind Me", comment: "")).font(.callout)
                        Spacer()
                        PerformableSwitch(isOn: $cdEvent.remindMe, perform: { isOn in
                            log.verbose("change remindMe to \(isOn)")
                            
                            // 弹出对话框，向用户请求推送通知的权限（如果已授权，则不会重复弹窗）
                            // 如果用户拒绝的话，那么后续添加到通知中心的“推送请求”都会被忽略。
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                                // do nothing
                            }
                        })
                    }.frame(height: 30)
                    
                    Divider()
                    
                    HStack {
                        Text(NSLocalizedString("Edit.Show Sticky Note", comment: "")).font(.callout)
                        Spacer()
                        PerformableSwitch(isOn: $cdEvent.showStickyNote, perform: { isOn in
                            log.verbose("change showStickyNote to \(isOn)")
                            if isOn {
                                StickyNoteController.shared.add(for: self.cdEvent)
                            } else {
                                StickyNoteController.shared.remove(for: self.cdEvent)
                            }
                        })
                    }.frame(height: 30)
                    
                    Divider()
                    
                    HStack {
                        Text(NSLocalizedString("Edit.Color", comment: "")).font(.callout)
                        Spacer()
                        
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(cdEvent.color))
                    }
                    .contentShape(Rectangle()) // 为了让整个区域都可点击
                    .onTapGesture {
                        self.showColorPalette.toggle()
//                        // 点击换下一个颜色
//                        let colorIndex = Theme.colors.firstIndex(where: {$0 == self.cdEvent.color}) ?? 0
//                        self.cdEvent.color = Theme.colors[(colorIndex + 1) % Theme.colors.count]
                    }.frame(height: 30)
                    
                    Divider()
                    
                    if showColorPalette {
                        HStack(spacing: 10.0) {
                            Spacer()
                            
                            ForEach(Theme.colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 28, height: 28)
                                    .onTapGesture {
                                        log.verbose("点击[\(color)]颜色")
                                        self.cdEvent.color = color
                                    }
                            }
                            
                            Button(action: {
                                log.verbose("点击调色盘")
                                let cp = NSColorPanel.shared
                                cp.color = self.cdEvent.color
                                cp.hidesOnDeactivate = false
                                cp.animationBehavior = .none
                                cp.center()
                                cp.orderFront(nil)
                            }){
                                Image("PaletteIcon").resizable().frame(width: 28, height: 28)
                            }.buttonStyle(BorderlessButtonStyle())
                        }.frame(height: 30)
                            .transition(AnyTransition.opacity.combined(with: AnyTransition.scale(scale: 0.1)).animation(.default))
                        Divider()
                    }
                }
            }
            .padding(.horizontal, Theme.popViewContentPaddingH)
            .padding(.top, Theme.popViewContentPaddingV)
        }
        .onAppear(perform: {
            if self.userData.currentPopContainedViewType == PopContainedViewType.add && self.cdEvent.showStickyNote {
                StickyNoteController.shared.add(for: self.cdEvent)
            }
        })
        .onDisappear(perform: {
            log.verbose("PopEventEdit view onDisappear")
            NSColorPanel.shared.orderOut(nil)
        })
        .onReceive(NotificationCenter.default.publisher(for: NSColorPanel.colorDidChangeNotification, object: NSColorPanel.shared), perform: { message in
            log.verbose("PopEventEdit[\(self.cdEvent.title)] 接收到 NSColorPanel.shared 的消息: \(message)")

            self.cdEvent.color = NSColorPanel.shared.color
        })
        .overlyingAlert(showAlert: $showDeleteAlert,
            title: NSLocalizedString("Edit.Delete.title", comment: ""),
            message: String.init(format: NSLocalizedString("Edit.Delete.message", comment: ""), cdEvent.title),
            confirmButton: Button(NSLocalizedString("Delete", comment: "")){
                log.verbose("在 Alert 中点击确认按钮")
                self.deleteCountdownEvent()
                self.showDeleteAlert = false
            },
            cancelButton: Button(NSLocalizedString("Cancel", comment: "")){
                log.verbose("在 Alert 中点击取消按钮")
                self.showDeleteAlert = false
            })
    }
    
    
    /// 删除当前编辑的 CountdownEvent
    /// 1. 如果是新建的 Countdown
    ///     a. 从 StickyNoteController 中删除便签视图
    ///     b. 从 UserDefaults 中删除保存的便签窗口信息
    /// 2. 如果是已存在的 Countdown
    ///     a. 从 UserData 全局数组中删除该事件
    ///     b. 从 EventListController 列表中删除该行
    ///     c. 从数据库中删除该事件
    private func deleteCountdownEvent() {
        // 从便利贴视图控制器中删除 cdEvent 的便利贴
        StickyNoteController.shared.remove(for: self.cdEvent)
        // 删除存储在 UserDefaults 中对应便利贴视图的窗口信息
        UserDefaults.standard.removeObject(forKey: "NSWindow Frame StickyNote | \(cdEvent.uuid.uuidString)")

        // 如果是编辑已存在的倒计时事件
        if self.userData.currentPopContainedViewType == PopContainedViewType.edit {
            guard let index = userData.countdownEvents.firstIndex(where: {$0.uuid == cdEvent.uuid}) else {
                log.error("在 UserData 中找不到 CountdownEvent 对象[\(cdEvent)]")
                return
            }
            
            // 从全局的 [CountdownEvent] 数组中删除该事件
            userData.countdownEvents.remove(at: index)
            
            // 在 EventListNSTableController 的 NSTableView 中删除对应行
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.eventListController.removeRow(at: index)

            // 从数据库中删除该事件
            self.cdEvent.delete(at: db)
        }

        // 跳转回列表视图
        withAnimation {
            self.userData.currentPopContainedViewType = .list
        }
    }
}

struct PopEventEdit_Previews: PreviewProvider {
    static var previews: some View {
        PopEventEdit()
            .frame(width: Theme.popViewWidth)
            .environmentObject(UserData.shared)
    }
}
