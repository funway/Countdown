//
//  EventRowStatic.swift
//  Countdown
//
//  Created by funway on 2020/10/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct EventRowStatic: View {
    let cdEvent: CountdownEvent
    let timeFormat: String
    
    #if DEBUG
    private let deallocPrinter: DeallocPrinter!
    #endif
    
    var progress: Double = 0
    var relativeTimeString: String = ""
    
    
    init(cdEvent: CountdownEvent) {
        self.cdEvent = cdEvent
        
        if (cdEvent.endAt.component(.hour) == 0 && cdEvent.endAt.component(.minute) == 0) {
            self.timeFormat = "yyyy/M/d"
        } else {
            self.timeFormat = "yyyy/M/d H:mm"
        }
        
        // 在构造器中对 @State 值进行初始化的正确方式
//        self._progress = State(initialValue: cdEvent.progress)
//        self._relativeTimeString = State(initialValue: cdEvent.endAt.toStringWithRelativeTime())
        
        #if DEBUG
        self.deallocPrinter = DeallocPrinter(forType: String(describing: Self.self) + "[\(cdEvent.title)]")
        #endif
    }
    
    var body: some View {
        ZStack {
            HStack {
                CircularProgress(progress: CGFloat(progress), foregroundColor: Color(cdEvent.color), lineWidth: 4)
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
                
               
            }
            
            
            
        }
        .onAppear(perform: {
            log.verbose("EventRow[\(self.cdEvent.title)] appear")
        })
        .onDisappear(perform: {
            log.verbose("EventRow[\(self.cdEvent.title)] disappear")
        })
    }
}

struct EventRowStatic_Previews: PreviewProvider {
    static var previews: some View {
        EventRowStatic(cdEvent: loadCountdownEvent()[1])
    }
}
