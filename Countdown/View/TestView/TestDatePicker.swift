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
            CustomNSDatePicker(date: $date, minDate: Date())
            
        }
    }
}

struct TestDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        TestDatePicker()
    }
}
