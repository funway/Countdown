//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI
import ServiceManagement
import UserNotifications

struct ContentView: View {
    @State var items = Array(1...500)

    var body: some View {
        VStack {
            Button("Shuffle") {
                self.items.shuffle()
            }

            List(items, id: \.self) {
                Text("Item \($0)")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
