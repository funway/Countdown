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
    
    @State var progress: Double
    @State var relativeTimeString: String
    @State var hovered: Bool = false
    @State var refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    #if DEBUG
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    #endif
    
    init(cdEvent: CountdownEvent) {
        self.cdEvent = cdEvent
        
        // 在构造器中对 @State 值进行初始化的正确方式
        self._progress = State(initialValue: cdEvent.progress)
        self._relativeTimeString = State(initialValue: cdEvent.endAt.toStringWithRelativeTime())
    }
    
    var body: some View {
            // 抬头按钮栏
            ZStack {
                
                // 进度条层
                CircularProgress(progress: CGFloat(progress), foregroundColor: Color(cdEvent.color.isLight() ? cdEvent.color.darkened() : cdEvent.color.tinted()), lineWidth: 8).padding(6.0)
                
                // 内容层
                VStack(spacing: 5.0){
                    Text(cdEvent.title)
                        .font(Font.system(size: 20, weight: .medium).monospacedDigit())
                    
                    Text(relativeTimeString)
                        .font(Font.system(size: 13, weight: .regular).monospacedDigit())
                }.padding(20)
                    .foregroundColor(cdEvent.color.isLight() ? .black : .white)
                
                // 按钮层
                VStack(spacing: 0.0) {
                    HStack() {
                        Spacer()
                        
                        if (hovered) {
                            Button(action: {
                                self.cdEvent.showStickyNote = false
                                self.cdEvent.save(at: db)
                                StickyNoteController.shared.remove(for: self.cdEvent)
                            }) {
                                Image("CloseIcon")
                                .resizable()
                            }.buttonStyle(PlainButtonStyle())
                            .frame(width: 20, height: 20)
                        }
                    }
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
                log.debug("hovered")
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

