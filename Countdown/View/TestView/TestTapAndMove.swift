//
//  TestTapAndMove.swift
//  Countdown
//
//  Created by funway on 2020/10/4.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI


//////////////
//class TapHandlerView: NSView {
//
//    override func mouseDown(with event: NSEvent) {
//        // 好像应该是 onMove 会截断所有的鼠标事件，所以 onMove 之后，mouseUp 就无法触发。
//        // 那么我们只能在这里用 mouseDown 了。
//        // 为了判断到底是 move 还是 down，可以先 ismove = false, 然后 super.mouseDown 调用 onmove，onmove中需要将 ismove 赋值为 true，最后返回mouseDown 继续执行后续操作前，先判断该 ismove，为 true 就不做后面操作。
//
//        super.mouseDown(with: event)   // keep this to allow drug !!
//        print("mouse down~")
//    }
//}
//
//struct TapHandler: NSViewRepresentable {
//    func makeNSView(context: Context) -> TapHandlerView {
//        TapHandlerView()
//    }
//
//    func updateNSView(_ nsView: TapHandlerView, context: Context) {
//    }
//}

////////////////

extension View {
    func onMouseUp(_ perform: @escaping () -> Void) -> some View {
        overlay(MouseDownAwareView(perform: perform))
    }
}

struct MouseDownAwareView: NSViewRepresentable {
    let perform: () -> Void
    
    init(perform: @escaping () -> Void) {
        self.perform = perform
    }
    
    func makeNSView(context: Context) -> NSMouseDownAwareView {
        NSMouseDownAwareView(perform: perform)
    }

    func updateNSView(_ nsView: NSMouseDownAwareView, context: Context) {
    }
}

extension MouseDownAwareView {
    
    final class NSMouseDownAwareView: NSView {
        let perform: () -> Void
        
        init(perform: @escaping () -> Void) {
            self.perform = perform
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func mouseDown(with event: NSEvent) {
//            let startTime = Date()
            print("NSMouseDownAwareView mouse down")
            
//            super.mouseDown(with: event)
//
//            log.debug(Date().timeIntervalSince1970 - startTime.timeIntervalSince1970)
//            // 只有 mouseDown - mouseUp 之间的间隔小于 0.2 秒才叫单击
//            if (Date().timeIntervalSince1970 - startTime.timeIntervalSince1970) < 0.2 {
//                self.perform()
//            }
        }
        
        override func mouseUp(with event: NSEvent) {
            print("NSMouseDownAwareView mouse upupup!")
        }
    }
}


struct TestTapAndMove: View {
    @State private var users = ["Paul", "Taylorsdfadalfdjalfkjdsafjdaskjf尽快了解了解卡利久里节快乐健康lkdsajflkdsajflaskdfjl", "Adele", "Zoe", "Cynnie", "Julia", "Funway"]
    @State var isMoving = false
    
    // For long press gesture
    @GestureState private var isPressed = false
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero

    var body: some View {
        VStack {
            List {
                ForEach(users, id: \.self) { user in
                    VStack {
                        Text("user: \(user)").font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                          
                        Divider()
                    }.background(Color.gray)
                        .onMouseUp {
                            if !self.isMoving {
                                print("mouse up")
                            }
                            self.isMoving = false
                            
                    }
                }
                .onMove(perform: move)
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        print("onMove!")
        
        self.isMoving = true
        
        users.move(fromOffsets: source, toOffset: destination)
    }
}
