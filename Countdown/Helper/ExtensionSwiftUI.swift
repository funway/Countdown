//
//  SwiftUIExtension.swift
//  Countdown
//
//  Created by funway on 2020/10/16.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import Foundation
import SwiftUI


extension SwiftUI.View {
    
    /// 给视图添加 tooltip 提示
    /// - Parameter toolTip: 提示字符串
    /// - Returns: 返回一个包含 tooltip 的视图
    func toolTip(_ toolTip: String) -> some SwiftUI.View {
        overlay(TooltipView(toolTip))
    }
    
    
    /// 给视图添加自定义 border
    /// - Parameters:
    ///   - width: <#width description#>
    ///   - edges: <#edges description#>
    ///   - color: <#color description#>
    /// - Returns: <#description#>
    func border(width: CGFloat, edges: [Edge], color: Color) -> some SwiftUI.View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    
    /// 覆盖在视图上的 Alert
    /// - Parameters:
    ///   - showAlert: 该 Binding 参数决定是否显示 Alert
    ///   - title: Alert 标题
    ///   - message: Alert 内容
    ///   - confirmButton: 确认按钮（需要在按钮事件中通过设置 showAlert 为 false 来手动关闭 Alert ）
    ///   - cancelButton: 取消按钮（需要在按钮事件中通过设置 showAlert 为 false 来手动关闭 Alert ）
    /// - Returns: some View
    func overlyingAlert(showAlert: Binding<Bool>,
                        title: String,
                        message: String? = nil,
                        confirmButton: Button<Text>,
                        cancelButton: Button<Text>? = nil) -> some View {
        
        if showAlert.wrappedValue {
            return AnyView(self.overlay(AlertView(showAlert: showAlert,
                                                  title: title,
                                                  message: message,
                                                  confirmButton: confirmButton,
                                                  cancelButton: cancelButton)))
        } else {
            return AnyView(self)
        }
    }
    
    
    @ViewBuilder func hide(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}


/// 通过包装一个 NSView 并设置其 tooTip 属性，返回 SwiftUI.View
/// 只在本文件中供 extension SwiftUI.View 使用
fileprivate struct TooltipView: NSViewRepresentable {
    let toolTip: String

    init(_ toolTip: String) {
        self.toolTip = toolTip
    }

    func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipView>) {
        nsView.toolTip = self.toolTip
    }
}


fileprivate struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}


fileprivate struct AlertView: SwiftUI.View {
    @Binding var showAlert: Bool
    let title: String
    let message: String?
    let confirmButton: Button<Text>
    let cancelButton: Button<Text>?
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())  // 为了让 Color.clear 也能被点击，而不是“透过去”
                .onTapGesture {
                    NSSound.beep()
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if message != nil {
                    Text(message!)
                }
                
                HStack {
                    if cancelButton != nil {
                        cancelButton?.padding(.horizontal)
                    }
                    
                    confirmButton.padding(.horizontal)
                }
            }
            .padding()
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(5)
            .shadow(radius: 5)
        }
    }
}


struct HyperLinkText: View {
    let text: String
    let destination: URL
    var body: some View {
        Button(action: {
            NSWorkspace.shared.open(self.destination)
        }, label: {
            Text(text)
                .foregroundColor(Color.blue)
        }).buttonStyle(PlainButtonStyle())
        .onHoverAware({ hovered in
            if hovered {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
    }
}


struct HyperLinkButton<Label> : View where Label : View {
    let label: () -> Label
    let destination: URL
    
    init(destination: URL, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            NSWorkspace.shared.open(self.destination)
        }, label: label)
        .onHoverAware({ hovered in
            if hovered {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
    }
}


struct SegmentedPicker: NSViewRepresentable {
    typealias NSViewType = NSSegmentedControl
    
    let labels: [String]
    let segmentDistribution: NSSegmentedControl.Distribution
    let segmentStyle: NSSegmentedControl.Style
    @Binding var selectedIndex: Int
    
    init(labels: [String],
         selectedIndex: Binding<Int>,
         segmentDistribution: NSSegmentedControl.Distribution = .fillEqually,
         segmentStyle: NSSegmentedControl.Style = .automatic) {
        
        self.labels = labels
        self._selectedIndex = selectedIndex
        self.segmentDistribution = segmentDistribution
        self.segmentStyle = segmentStyle
    }
    
    
    func makeCoordinator() -> SegmentedPicker.Coordinator {
        return Coordinator(selectedIndex: $selectedIndex)
    }
    
    func makeNSView(context: Context) -> NSSegmentedControl {
        let control = NSSegmentedControl(
            labels: labels,
            trackingMode: .selectOne,
            target: context.coordinator,
            action: #selector(Coordinator.onChange(sender:))
        )
        
        control.segmentDistribution = segmentDistribution
        control.segmentStyle = segmentStyle
        
        return control
    }
    
    func updateNSView(_ nsView: NSSegmentedControl, context: Context) {
        nsView.selectedSegment = selectedIndex
    }
    
    class Coordinator: NSObject {
        @Binding var selectedIndex: Int
        
        init(selectedIndex: Binding<Int>) {
            self._selectedIndex = selectedIndex
        }
        
        @objc func onChange(sender: NSSegmentedControl) {
            selectedIndex = sender.selectedSegment
        }
    }
}


/// 将一个 NSSwitch 包装成 View，并提供事件响应函数
struct PerformableSwitch: NSViewRepresentable {
    typealias NSViewType = NSSwitch
    
    /// NSSwitch 状态关联的布尔值
    @Binding var isOn: Bool
    
    /// NSSwitch 状态变化时候调用的函数
    let perform: (Bool) -> Void
    
    /// 将一个 NSSwitch 包装成 View，并提供事件响应函数
    /// - Parameters:
    ///   - isOn: 与 NSSwitch 状态关联的布尔值
    ///   - perform: NSSwitch 状态变换时候调用的函数
    init(isOn: Binding<Bool>, perform: @escaping (Bool) -> Void = {_ in}) {
        self._isOn = isOn
        self.perform = perform
    }
    
    // 构建 View 时调用该函数，该函数必须返回我们想要包装的 NSView 对象
    // 注意！不需要，也不应该将这个 NSView 对象设置成当前 NSViewRepresentable 子类的存储属性
    func makeNSView(context: Context) -> NSSwitch {
        let toggle = NSSwitch()
        toggle.state = isOn ? .on : .off
        
        toggle.target = context.coordinator
        toggle.action = #selector(Coordinator.onChanged(sender:))
        
        return toggle
    }
    
    // 刷新 View 时调用该函数，在该函数中更新 NSView 对象
    func updateNSView(_ nsView: NSSwitch, context: Context) {
        nsView.state = isOn ? .on : .off
    }
    
    // 返回一个协同器对象，该方法会在 makeNSView() 之前调用
    // 协同器对象会保存在 context.coordinator 属性中，给 makeNSView 与 updateNSView 调用
    func makeCoordinator() -> Coordinator {
        return Coordinator(isOn: $isOn, perform: perform)
    }
    
    // 自定义协同器类
    class Coordinator: NSObject {
        // 绑定 SwiftUI 中需要交互的数据
        @Binding var isOn: Bool
        let perform: (Bool) -> Void

        init(isOn: Binding<Bool>, perform: @escaping (Bool) -> Void) {
            self._isOn = isOn       // 注意！这是在构造器中传递 @Binding 属性的正确方式
            self.perform = perform
        }

        @objc func onChanged(sender: NSSwitch){
            self.isOn = sender.state == .on ? true : false
            perform(self.isOn)
        }
    }
}


struct CustomNSDatePicker: NSViewRepresentable {
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
    func makeCoordinator() -> CustomNSDatePicker.Coordinator {
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


extension Color {
    /// 从颜色的 hex 值构造 Color 对象。比如：let aliceBlue = Color(hex: 0xf0f8ff)
    /// - Parameter hex: 0xRRGGBB
    init(hex: Int) {
        self.init(red: Double((hex >> 16) & 0xff) / 255, green: Double((hex >> 8) & 0xff) / 255, blue: Double(hex & 0xff) / 255)
    }
}


extension NSColor {
    /// 从颜色的 hex 值构造 NSColor 对象。比如：let aliceBlue = NSColor(hex: 0xf0f8ff)
    /// - Parameter hex: 0xRRGGBB
    convenience init(hex: Int) {
        self.init(red: CGFloat(Double((hex >> 16) & 0xff) / 255), green: CGFloat(Double((hex >> 8) & 0xff) / 255), blue: CGFloat(Double(hex & 0xff) / 255), alpha: 1.0)
    }
    
    
    /// 获取 NSColor rgb 值的整形表示
    var rgbValue: Int {
        let ciColor = CIColor(color: self)!
        
        let r = Int(ciColor.red*255)
        let g = Int(ciColor.green*255)
        let b = Int(ciColor.blue*255)
        
        return (r << 16) + (g << 8) + (b << 0)
    }
}
