//
//  EventRow.swift
//  Countdown
//
//  Created by funway on 2020/7/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct EventRow: View {
    @State var hovered = false
    var cdEvent: CountdownEvent
    
    var body: some View {
        HStack {
            Circle().frame(width: 20, height: 20)
            
            VStack {
                Text(cdEvent.title)
                
            }
            
            Spacer()
            
            Text("结束")
            
            if hovered {
                Button(action: {}) {
                    Image("RightIcon")
                }
                .buttonStyle(BorderlessButtonStyle())
                .transition(.move(edge: .trailing))
            }
        }
        .frame(height: 40)
        .onHover { over in
            withAnimation{
                self.hovered = over
            }
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(cdEvent: cdEvents[0])
    }
}
