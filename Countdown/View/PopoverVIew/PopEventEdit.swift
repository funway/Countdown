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
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    
    init(cdEvent: CountdownEvent? = nil) {
        log.verbose("初始化 PopEventEdit 视图")
        
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
        self.timeFormatter.dateFormat = "HH:mm"
        
        self.cdEvent = cdEvent ?? CountdownEvent(title: "Untitled",
                                                 endAt: Date().dateFor(.tomorrow).dateFor(.startOfDay),
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
                    
                    // 如果是新增的倒计时事件，将 cdEvent 写入全局的 [CountdownEvent] 数组
                    if self.userData.currentPopContainedViewType == PopContainedViewType.add {
                        self.userData.countdownEvents.insert(self.cdEvent, at: 0)
                    }
                    
                    // 返回列表视图
                    withAnimation {
                        self.userData.currentPopContainedViewType = .list
                    }
                }) {
                    Image("BackIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                    .toolTip("保存并返回")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                if PopContainedViewType.add == userData.currentPopContainedViewType {
                    Text("Add").font(.headline)
                } else {
                    Text("Edit").font(.headline)
                }
                
                Spacer()
                
                // 删除按钮
                Button(action: {
                    log.verbose("点击删除按钮")
                    if PopContainedViewType.add == self.userData.currentPopContainedViewType {
                        self.deleteCountdownEvent()
                    } else {
                        self.showDeleteAlert.toggle()
                    }
                }) {
                    Image("TrashIcon")
                    .resizable()
                    .frame(width: Theme.popViewHeaderIconWidth, height: Theme.popViewHeaderIconWidth)
                    .toolTip("删除")
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
                    Text("Title")
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
                                Text("Date")
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
                                                   label: { Text("日期") })
                                            .datePickerStyle(GraphicalDatePickerStyle())
                                            .labelsHidden()
                                            .padding()
                                    })
                                    
                                    Text(self.dateFormatter.string(from: self.cdEvent.endAt))
                                        .font(Font.callout.monospacedDigit())
                                        
                                    Spacer()
                                }
                            }.frame(width: geometry.size.width/2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.calenderBtnClicked.toggle()
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                                Text("Time").font(.caption)
                                
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
                                                   label: { Text("时间") })
                                            .datePickerStyle(GraphicalDatePickerStyle())
                                            .labelsHidden()
                                            .padding()
                                    })
                                    
                                    Text(self.timeFormatter.string(from: self.cdEvent.endAt))
                                        .font(Font.callout.monospacedDigit())
                                    
                                    Spacer()
                                }
                            }.frame(width: geometry.size.width/2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.clockBtnClicked.toggle()
                            }
                        }.frame(width: geometry.size.width)
                    }.frame(height: 40)
                    
                    Divider()
                }
                
                // 勾选项 section
                VStack(alignment: .leading, spacing: Theme.popViewContentSectionSpacingV) {
                    HStack {
                        Text("Remind Me").font(.callout)
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
                        Text("Show Sticky Note").font(.callout)
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
                        Text("Color").font(.callout)
                        Spacer()
                        
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(cdEvent.color))
                    }
                    .contentShape(Rectangle()) // 为了让整个区域都可点击
                    .onTapGesture {
                        // 点击换下一个颜色
                        let colorIndex = Theme.colors.firstIndex(where: {$0 == self.cdEvent.color}) ?? 0
                        self.cdEvent.color = Theme.colors[(colorIndex + 1) % Theme.colors.count]
                    }.frame(height: 30)
                    
                    Divider()
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
        .overlyingAlert(showAlert: $showDeleteAlert,
            title: "确认删除?",
            message: "删除倒计时【\(cdEvent.title)】",
            confirmButton: Button("删除"){
                log.verbose("在 Alert 中点击确认按钮")
                self.deleteCountdownEvent()
                self.showDeleteAlert = false
            },
            cancelButton: Button("取消"){
                log.verbose("在 Alert 中点击取消按钮")
                self.showDeleteAlert = false
            })
    }
    
    
    /// 删除当前编辑的 CountdownEvent
    private func deleteCountdownEvent() {
        // 从便利贴视图控制器中删除 cdEvent 的便利贴
        StickyNoteController.shared.remove(for: self.cdEvent)

        // 如果是编辑已存在的倒计时事件
        if self.userData.currentPopContainedViewType == PopContainedViewType.edit {
            // 从全局的 [CountdownEvent] 数组中删除该事件
            self.userData.countdownEvents.removeAll(where: {$0.uuid == self.cdEvent.uuid})

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
