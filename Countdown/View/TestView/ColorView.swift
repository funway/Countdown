//
//  ColorView.swift
//  Countdown
//
//  Created by funway on 2020/8/30.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    @State var hovered: Bool = false
    
    #if DEBUG
    private let deallocPrinter = DeallocPrinter(forType: String(describing: Self.self))
    #endif
    
    var body: some View {
        VStack {
            Text("颜色啊")
            
            VStack(spacing: 1) {
                ForEach(Theme.colors, id: \.self) { color in
                    ZStack {
                        Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color(color))
                        .frame(width: 600, height: 50)
                        
                        HStack(spacing: 3) {
                            Text("hello")
                            
                            Text(color.isLight() ? "light" : "dark")
                                .foregroundColor(color.isLight() ? Color.black : Color.white)
                        }.font(.body)
                    }
                }
            }
        }
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
