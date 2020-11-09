//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var show = false

    var body: some View {
        VStack {
            Button("show/hide"){
                self.show.toggle()
            }

            Divider()

            if show {
                Text("hello")
                    .transition(.move(edge: .top))
                    .animation(.default)
            }
        }.padding()
    }
}

//struct ContentView: View {
//    @State var show = false
//
//    var body: some View {
//        VStack {
//            Button("show/hide"){
//                withAnimation {
//                    self.show.toggle()
//                }
//            }
//
//            Divider()
//
//            if show {
//                Text("hello")
//                    .transition(.move(edge: .top))
//            }
//        }.padding()
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
