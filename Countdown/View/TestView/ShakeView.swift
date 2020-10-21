//
//  ShakeView.swift
//  Countdown
//
//  Created by funway on 2020/10/3.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ShakeView: View {
    @State var invalidAttempts = 0
    
    var body: some View {
        VStack {
            Button(action: {
                self.invalidAttempts += 1
            }) { Text("Shake") }
            Rectangle()
                .fill(Color.purple)
                .frame(width: 200, height: 200)
                .modifier(ShakeEffect(shakes: invalidAttempts * 2))
                .animation(Animation.linear)
        }
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        print(position)
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct ShakeView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeView()
    }
}
