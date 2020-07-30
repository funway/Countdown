//
//  ContentView.swift
//  Countdown
//
//  Created by funway on 2020/7/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Circle()
                .fill(Color.blue)
                .overlay(Circle().strokeBorder(Color.white).padding(3))
                .overlay(Text("Start").foregroundColor(.white))
                .frame(width:75,height:75)
               
            
            Divider()
            
            Text("我爱北京天安门")
                .foregroundColor(.white)
            .padding(10)
            .background(
                GeometryReader { proxy in
                    Circle()
                        .fill(Color.blue)
                        .frame(width:proxy.size.width,height:proxy.size.width)
                    
                }
            
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
