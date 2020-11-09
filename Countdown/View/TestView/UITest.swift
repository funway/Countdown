//
//  UITest.swift
//  Countdown
//
//  Created by funway on 2020/8/7.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import Cocoa
import Combine

struct UITest: View {
    @State var date = Date().addingTimeInterval(3600)
    @State var showingPopup: Bool = false
    @State var stepperValue: Int = 1
    @State var inputText: String = ""
    @State var selectedColor = NSColor.blue
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            ZStack {
                Rectangle().fill(Color.secondary).opacity(0.2)
                    .gesture(TapGesture(count: 1).onEnded {
                        log.debug("rect single clicked")
                    }).frame(height: 50)
                
                Circle().fill(Color.red).frame(width: 50, height: 50)
                .gesture(TapGesture(count: 2).onEnded {
                    log.debug("circle double clicked")
                })
            }
            
            VStack {
                // 妈的 datepicker 有 BUG 啊！！！
                DatePicker(selection: $date, label: { Text("日期") })
                
                DatePicker(selection: $date, label: { Text("日期") })
                    .datePickerStyle(FieldDatePickerStyle())
                
                DatePicker(selection: $date, in: Date()..., label: { Text("日期") })
                    .datePickerStyle(StepperFieldDatePickerStyle())
                
                DatePicker(selection: $date, displayedComponents: [.hourAndMinute], label: { Text("时间") })
                .datePickerStyle(StepperFieldDatePickerStyle())
                
                HStack {
                    DatePicker(selection: $date, displayedComponents: [.date], label: { Text("日期") })
                    .datePickerStyle(GraphicalDatePickerStyle())
                    
                    DatePicker(selection: $date, displayedComponents: [.hourAndMinute], label: { Text("时间") })
                    .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                HStack {
                    Text("Choose a color:")
                    EmbeddedColorWell(selectedColor: $selectedColor)
                        .frame(width: 24, height: 23)
                }
                
                Button("popover button") {
                    self.showingPopup.toggle()
                }.popover(isPresented: $showingPopup) {
                    VStack {
                        Text("弹出按钮哦")
                    }
                }
                
            }
            
            HStack {
                Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                }
                .pickerStyle(PopUpButtonPickerStyle())
                Stepper(value: $stepperValue, in: 1...31) {
                    Text("Stepper")
                }
                Spacer()
            }
            
            VStack {
                Text("输入框: \(inputText)")
                    .font(.title)
                    .frame(width: 330, height:33)
                    .minimumScaleFactor(0.2)
                
                TextField("Title", text: $inputText)
                    .font(.title)
                    .frame(width: 330, height:33)
                    .textFieldStyle(PlainTextFieldStyle())
                    .scaledToFit()
                    .minimumScaleFactor(0.4)
                
                NoFocusTextField(text: $inputText)
                    .font(.title)
                    .frame(width: 330, height:33)
                    .background(Color.yellow)
            }
            Spacer()
        }
    }
}

struct UITest_Previews: PreviewProvider {
    static var previews: some View {
        UITest()
    }
}


fileprivate struct EmbeddedColorWell: NSViewRepresentable {
    @Binding var selectedColor: NSColor
    
    class Coordinator: NSObject {
        var embedded: EmbeddedColorWell
        var subscription: AnyCancellable?

        init(_ embedded: EmbeddedColorWell) {
            self.embedded = embedded
        }
        
        // Observe KVO compliant color property on NSColorWell object.
        // Update the selectedColor property on EmbeddedColorWell as needed.
        func changeColor(colorWell: NSColorWell) {
            subscription = colorWell
                .publisher(for: \.color, options: .new)
                .sink { color in
                    DispatchQueue.main.async {
                        self.embedded.selectedColor = color
                    }
            }
        }
    }
    
    func makeCoordinator() -> EmbeddedColorWell.Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell(frame: .zero)
        context.coordinator.changeColor(colorWell: colorWell)
        return colorWell
    }
    
    func updateNSView(_ nsView: NSColorWell, context: Context) {
        nsView.color = selectedColor
    }
}


struct NoFocusTextField: NSViewRepresentable {
    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(string: text)
        textField.delegate = context.coordinator
        textField.isBordered = false
        textField.backgroundColor = nil
        textField.focusRingType = .none
        textField.font = NSFont.systemFont(ofSize: 70)
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator { self.text = $0 }
    }

    final class Coordinator: NSObject, NSTextFieldDelegate {
        var setter: (String) -> Void

        init(_ setter: @escaping (String) -> Void) {
            self.setter = setter
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                setter(textField.stringValue)
            }
        }
    }
}
