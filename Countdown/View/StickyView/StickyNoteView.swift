//
//  StickyNoteView.swift
//  Countdown
//
//  Created by funway on 2020/8/25.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import DynamicColorMacOS

struct StickyNoteView: View {
    @ObservedObject var cdEvent: CountdownEvent
    weak var window: NSWindow?
    
    @State var progress: Double
    @State var relativeTimeString: String
    @State var hovered: Bool = false
    @State var refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    #if DEBUG
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    #endif
    
    init(cdEvent: CountdownEvent, window: NSWindow? = nil) {
        self.cdEvent = cdEvent
        self.window = window
        
        // 在构造器中对 @State 值进行初始化的正确方式
        self._progress = State(initialValue: cdEvent.progress)
        self._relativeTimeString = State(initialValue: cdEvent.endAt.toStringWithRelativeTime())
    }
    
    var body: some View {
            // 抬头按钮栏
            ZStack {
                
                // 进度条层
                CircularProgress(progress: CGFloat(progress), foregroundColor: Color(cdEvent.color.isLight() ? cdEvent.color.darkened() : cdEvent.color.tinted()), lineWidth: 8, clockwise: false).padding(6.0)
                
                // 内容层
                VStack(spacing: 10) {
                    Text(cdEvent.title)
                        .font(Font.system(size: 20, weight: .medium).monospacedDigit())
                    
                    Text(relativeTimeString)
                        .font(Font.system(size: 13, weight: .regular).monospacedDigit())
                }.minimumScaleFactor(0.5)
                .padding(35)
                .foregroundColor(cdEvent.color.isLight() ? .black : .white)
                
                // 按钮层
                VStack(spacing: 0.0) {
                    HStack() {
                        if (hovered) {
                            Button(action: {
                                self.cdEvent.showStickyNote = false
                                self.cdEvent.save(at: db)
                                StickyNoteController.shared.remove(for: self.cdEvent)
                            }) {
                                Image("CloseIcon").resizable().frame(width: 18, height: 18)
                            }.buttonStyle(BorderlessButtonStyle())
                            .colorScheme(self.cdEvent.color.isLight() ? .light : .dark)
                        }
                        
                        Spacer()
                        
                        if (hovered) {
                            Button(action: {
                                log.verbose("click pin button")
                                self.cdEvent.stickyNoteIsFloating.toggle()
                                self.cdEvent.save(at: db)
                                
                                if self.cdEvent.stickyNoteIsFloating {
                                    log.verbose("StickyNote[\(self.cdEvent.title)] 设置为 floating")
                                    self.window?.level = .floating
                                } else {
                                    log.verbose("StickyNote[\(self.cdEvent.title)] 设置为 normal")
                                    self.window?.level = .normal
                                }
                            }) {
                                Image("PinIcon").resizable().frame(width: 15, height: 15).offset(x: 0, y: self.cdEvent.stickyNoteIsFloating ? 5 : 0)
                            }.buttonStyle(BorderlessButtonStyle())
                            .colorScheme(self.cdEvent.color.isLight() ? .light : .dark)
                        }
                    }.padding(3)
                    Spacer()
                }
                
            }.frame(width: 180, height: 180)
            .background(Color(cdEvent.color))
            .onAppear(){
                self.refreshTimer.upstream.connect().cancel()
                self.refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
            .onDisappear(){
                self.refreshTimer.upstream.connect().cancel()
            }
            .onReceive(refreshTimer) { currentTime in
                self.refresh()
            }
            .onHoverAware({ hovered in
                self.hovered = hovered
            })
    }
    
    func refresh() {
        progress = cdEvent.progress
        relativeTimeString = cdEvent.endAt.toStringWithRelativeTime()
    }
}

struct StickyNoteView_Previews: PreviewProvider {
    static var previews: some View {
        StickyNoteView(cdEvent: loadCountdownEvent()[1])
    }
}

