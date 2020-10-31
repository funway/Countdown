//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime: Date = Date()

    var body: some View {
        VStack {
            Button("start"){
                AppTimer.shared.start()
            }
            Button("stop"){
                AppTimer.shared.stop()
            }
            
            Divider()
            
            Text("\(currentTime)")
        }.onReceive(AppTimer.shared.$ticktock, perform: { currentTime in
            self.currentTime = currentTime
            log.debug("contentview receie timer")
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
