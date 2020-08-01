//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var users = ["Paul", "Taylor", "Adele"]
    @State private var overText = false
    @State private var progress = 0.5


    var body: some View {
        VStack {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
            }
            
            Divider()
            
            Text("Hello, World!")
            .foregroundColor(overText ? Color.green : Color.red)
            .onHover { over in
                self.overText = over
            }
            
            Divider()
            
            Button(">>>") {
                self.progress += 0.05
            }
            
            HStack(spacing: 10) {
                LinearProgress(progress: CGFloat(self.progress)).frame(width:100, height: 20)
                
                CircularProgress(progress: CGFloat(self.progress)).frame(width: 100, height: 100)
                    .overlay(Text("\(Int(progress*100))%"))
                
                FilledCircleProgress(progress: CGFloat(self.progress)).frame(width: 100, height: 100)
                
                ArcProgress(progress: CGFloat(self.progress)).frame(width: 100, height: 50)
                    .overlay(Text("\(Int(progress*100))%"))
            }
            
        }.padding(.all, 10)
    }

    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
