//
//  ColorView.swift
//  Countdown
//
//  Created by funway on 2020/8/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    let cp: MyNSColorPanel
    @State var hovered: Bool = false
    @State var color1: NSColor = .red
    @State var color2: NSColor = .green
    @State var color3: NSColor = .blue
    @State var coordinator: Coordinator? = nil
    
    init() {
        let _ = NSColorPanel.shared
        MyNSColorPanel.setPickerMask([.grayModeMask, .rgbModeMask, .colorListModeMask])
        cp = MyNSColorPanel()
        log.debug("new address: \(cp)")
        log.debug("shared address: \(MyNSColorPanel.shared)")
        log.debug("isReleasedWhenClosed? \(cp.isReleasedWhenClosed)")
    }
    
    #if DEBUG
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    #endif
    
    var body: some View {
        VStack {
            Text("颜色啊")
            
            VStack(spacing: 10) {
                HStack(spacing: 5) {
                    ForEach(Theme.colors, id: \.self) { color in
                        ZStack {
                            Circle()
                                .fill(Color(color))
                                .frame(width: 50, height: 50)
                            
                            HStack {
                                Text(color.isLight() ? "L" : "D")
                                    .foregroundColor(color.isLight() ? Color.black : Color.white)
                                    .font(Font.system(size: 13, weight: .bold, design: .monospaced))
                            }
                        }
                    }
                }
                Divider()
                HStack {
                    Rectangle().fill(Color(color1)).frame(width: 80, height: 30)
                    Rectangle().fill(Color(color2)).frame(width: 80, height: 30)
                    Rectangle().fill(Color(color3)).frame(width: 80, height: 30)
                }
                HStack {
                    Button("Color1"){
                        self.cp.color = self.color1
//                        self.cp.setTarget(self.coordinator!)
//                        self.cp.setAction(#selector(Coordinator.onColorChanged(sender:)))
                        self.cp.orderFront(nil)
                    }.frame(width: 80, height: 30)
                    
                    Button("Color2"){
                        let cp = NSColorPanel.shared
                        log.debug("new address: \(cp)")
                        log.debug("shared address: \(NSColorPanel.shared)")
                        cp.color = self.color2
                        
                        cp.orderFront(nil)
                    }.frame(width: 80, height: 30)
                    
                    CustomNSColorWell(color: $color3).frame(width: 80, height: 30)
                }
            }
        }
        .onAppear(){
            if self.coordinator == nil {
                self.coordinator = Coordinator(color: self.$color1)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSColorPanel.colorDidChangeNotification, object: NSColorPanel.shared), perform: { v in
            log.debug("接收到 colorpannel.shared 消息: \(v)")

            self.color2 = NSColorPanel.shared.color
        })
        .onReceive(NotificationCenter.default.publisher(for: NSColorPanel.colorDidChangeNotification, object: self.cp), perform: { v in
            log.debug("接收到 colorpannel_1 消息: \(v)")

            self.color1 = self.cp.color
        })
    }
    
    // 自定义协同器类
    class Coordinator: NSObject {
        // 绑定 SwiftUI 中需要交互的数据
        @Binding var color: NSColor
        
        // 注意！这是在构造器中传递 @Binding 属性的正确方式
        init(color: Binding<NSColor>) {
            self._color = color
        }
        
        @objc func onColorChanged(sender: NSColorPanel){
            log.verbose("Coordinator color1 changed: \(sender)")
            self.color = sender.color
        }
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}


struct CustomNSColorWell: NSViewRepresentable {
    typealias NSViewType = NSColorWell
    
    @Binding var color: NSColor
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(color: $color)
    }
    
    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell()
        colorWell.target = context.coordinator
        colorWell.action = #selector(Coordinator.onColorChanged(sender:))
        return colorWell
    }
    
    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = color
    }
    
    // 自定义协同器类
    class Coordinator: NSObject {
        // 绑定 SwiftUI 中需要交互的数据
        @Binding var color: NSColor
        
        // 注意！这是在构造器中传递 @Binding 属性的正确方式
        init(color: Binding<NSColor>) {
            self._color = color
        }
        
        @objc func onColorChanged(sender: NSColorWell){
            log.verbose("NSColorWell color3 changed \(sender)")
            self.color = sender.color
        }
    }
}


class MyNSColorPanel: NSColorPanel {
    deinit {
        log.debug("释放啦")
    }
}
