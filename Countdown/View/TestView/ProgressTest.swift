//
//  ProgressTest.swift
//  Countdown
//
//  Created by funway on 2020/8/8.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ProgressTest: View {
    @State private var users = ["Paul", "Taylor", "Adele"]
    @State private var overText = false
    @State private var progress = 0.3 {
        didSet {
            if progress > 1.1 {
                progress = 0.1
            }
        }
    }
    @State var date = Date()
    
    var updateTimer: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
                                 self.date = Date()
                               })
    }

    var body: some View {
        VStack {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
            }
            
            Divider()
            
            Text("\(date)")
            .foregroundColor(overText ? Color.green : Color.red)
            .onHover { over in
                self.overText = over
            }
            .onAppear(perform: {let _ = self.updateTimer})
            
            Divider()
            
            Button(">>>") {
                log.debug("click >>>")
                self.progress += 0.15
            }
            
            HStack(spacing: 10) {
                LinearProgress(progress: CGFloat(self.progress)).frame(width:100, height: 20)
                
                CircularProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 42/255, green: 157/255, blue: 143/255))
                    .frame(width: 100, height: 100)
                    .overlay(Text("\(Int(progress*100))%"))
                
                FilledCircleProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 179/255, green: 146/255, blue: 172/255)).frame(width: 100, height: 100)
                
                ArcProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 5/255, green: 102/255, blue: 141/255)).frame(width: 100, height: 50)
                    .overlay(Text("\(Int(progress*100))%"))
            }
            
            HStack(spacing: 10) {
                LinearProgress(progress: CGFloat(self.progress), backward: true).frame(width:100, height: 20)
                
                CircularProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 42/255, green: 157/255, blue: 143/255), clockwise: false)
                    .frame(width: 100, height: 100)
                    .overlay(Text("\(Int(progress*100))%"))
                
                FilledCircleProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 179/255, green: 146/255, blue: 172/255), clockwise: false).frame(width: 100, height: 100)
                
                ArcProgress(progress: CGFloat(self.progress), foregroundColor: Color(red: 5/255, green: 102/255, blue: 141/255), clockwise: false).frame(width: 100, height: 50)
                    .overlay(Text("\(Int(progress*100))%"))
            }
            
            Circle()
                .fill(Color(red: 5/255, green: 102/255, blue: 141/255))
                .frame(width: 100, height: 100)
            
        }.padding(.all, 10)
    }

    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

struct ProgressTest_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTest()
    }
}
