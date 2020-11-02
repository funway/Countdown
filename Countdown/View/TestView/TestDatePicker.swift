//
//  TestDatePicker.swift
//  Countdown
//
//  Created by funway on 2020/11/1.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestDatePicker: View {
    @State var date = Date()
    @State var calenderBtnClicked = false
    @State var clockBtnClicked = false
    
    var body: some View {
        VStack {
            Text(date.toString())
            Divider()
            
            // 妈的 datepicker 有 BUG 啊！！！
            DatePicker(selection: $date, label: { Text("日期") })
            
            DatePicker(selection: $date, label: { Text("日期") })
                .datePickerStyle(FieldDatePickerStyle())
            
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
                                    
                                    DatePicker(selection: self.$date,
                                               displayedComponents: [.date],
                                               label: { Text("日期") })
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                        .padding()
                                })
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
                                    
                                    DatePicker(selection: self.$date,
                                               displayedComponents: [.hourAndMinute],
                                               label: { Text("时间") })
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                        .padding()
                                })
                                
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
            
            Divider()
            HStack {
                TestCustomNSDatePicker(date: $date, style: .textField, elements: .yearMonthDay)
                    .frame(width: 90)
                
                Spacer()
                
                TestCustomNSDatePicker(date: $date, elements: .hourMinute)
                    .frame(width: 90)
            }
            
        }.padding()
    }
}

struct TestDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        TestDatePicker()
    }
}


struct TestCustomNSDatePicker: NSViewRepresentable {
    @Binding var date: Date
    
    let style: NSDatePicker.Style
    let elements: NSDatePicker.ElementFlags
    let locale: Locale?
    let minDate: Date?
    let maxDate: Date?
    
    init(date: Binding<Date>,
         style: NSDatePicker.Style = .textFieldAndStepper,
         elements: NSDatePicker.ElementFlags = [.yearMonthDay, .hourMinute],
         locale: Locale? = Locale.current,
         minDate: Date? = nil,
         maxDate: Date? = nil) {
        
        self._date = date
        self.style = style
        self.elements = elements
        self.locale = locale
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    // 构建 View 时调用该函数，该函数必须返回我们想要包装的 NSView 对象
    // 注意！不需要，也不应该将这个 NSView 对象设置成当前 NSViewRepresentable 子类的存储属性
    func makeNSView(context: Context) -> NSDatePicker {
        
        let datePicker = NSDatePicker()
        datePicker.dateValue = date
        
        datePicker.datePickerStyle = style
        datePicker.datePickerElements = elements
        datePicker.locale = locale
        datePicker.minDate = minDate
        datePicker.maxDate = maxDate
        
//        datePicker.isBordered = false
        datePicker.isBezeled = false
        
        // 设置 datePicker 的事件处理
        // 将事件发送目标指向协同器
        datePicker.target = context.coordinator
        // 将事件处理函数指向协同器中的方法。#selector 只需要指定函数入口，sender 实参会自动传递
        datePicker.action = #selector(Coordinator.onDateChanged(sender:))
        
        return datePicker
    }
    
    // 刷新 View 时调用该函数，在该函数中更新 NSView 对象
    func updateNSView(_ nsView: NSDatePicker, context: Context) {
        nsView.dateValue = date
    }
    
    // 返回一个协同器对象，该方法会在 makeNSView() 之前调用
    // 协同器对象会保存在 context.coordinator 属性中，给 makeNSView 与 updateNSView 调用
    func makeCoordinator() -> TestCustomNSDatePicker.Coordinator {
        return Coordinator(date: $date)
    }
    
    // 自定义协同器类
    class Coordinator: NSObject {
        // 绑定 SwiftUI 中需要交互的数据
        @Binding var date: Date

        // 注意！这是在构造器中传递 @Binding 属性的正确方式
        init(date: Binding<Date>) {
            self._date = date
        }

        @objc func onDateChanged(sender: NSDatePicker){
            self.date = sender.dateValue
        }
    }
}
