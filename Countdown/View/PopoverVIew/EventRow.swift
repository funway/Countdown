//
//  EventRow.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import Combine

struct EventRow: View {
    let cdEvent: CountdownEvent
    let timeFormat: String
    
    #if DEBUG
    private let deallocPrinter: DeallocPrinter!
    #endif
    
    @State var hovered = false
    @State var progress: Double
    @State var relativeTimeString: String
    
    
    init(cdEvent: CountdownEvent) {
        self.cdEvent = cdEvent
        
        if (cdEvent.endAt.component(.hour) == 0 && cdEvent.endAt.component(.minute) == 0) {
            self.timeFormat = "yyyy/M/d"
        } else {
            self.timeFormat = "yyyy/M/d H:mm"
        }
        
        // 在构造器中对 @State 值进行初始化的正确方式
        self._progress = State(initialValue: cdEvent.progress)
        self._relativeTimeString = State(initialValue: cdEvent.endAt.toStringWithRelativeTime())
        
        #if DEBUG
        self.deallocPrinter = DeallocPrinter(forType: String(describing: Self.self) + "[\(cdEvent.title)]")
        #endif
    }
    
    var body: some View {
        ZStack {
            HStack {
                CircularProgress(progress: CGFloat(progress), foregroundColor: Color(cdEvent.color), lineWidth: 4, clockwise: false)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text(cdEvent.title)
                        .font(Font.system(size: 13, weight: .medium).monospacedDigit())
                    Text(cdEvent.endAt.toString(format: .custom(timeFormat)))
                        .font(Font.system(size: 12, weight: .light).monospacedDigit())
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5.0) {
                    Text(relativeTimeString)
                        .font(Font.system(size: 13, weight: .medium).monospacedDigit())
                    Text(String(format: "%.1f%%", (progress * 1000).rounded(.down) / 10))
                        .font(Font.system(size: 12, weight: .light).monospacedDigit())
                }
                
                if hovered {
                    Image("RightIcon")
                        .opacity(0.5)
                        .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            
            if hovered {
                 Rectangle()
                     .fill(LinearGradient(
                        gradient: .init(colors: [.clear, .secondary, .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                     )).opacity(0.1)
            }
            
        }
        .frame(height: Theme.popViewEventRowHeight)
        .onAppear(perform: {
            self.refresh()
        })
        .onReceive(AppTimer.shared.$ticktock) { currentTime in
            self.refresh()
        }
        .onHoverAware { hovered in
            withAnimation {
                self.hovered = hovered
            }
        }
    }
    
    func refresh() {
        progress = cdEvent.progress
        relativeTimeString = cdEvent.endAt.toStringWithRelativeTime()
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(cdEvent: loadCountdownEvent()[1])
            .frame(width: 360)
            .padding(.horizontal, 10)
    }
}
