//
//  FilledCircleProgress.swift
//  ProgressView
//
//  Created by funway on 2020/7/31.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct FilledCircleProgress: View {
    var progress: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var animationTimeInterval: TimeInterval
    
    public init(progress: CGFloat, backgroundColor : Color = .gray, foregroundColor: Color = .pink,
                animationTimeInterval: TimeInterval = 0.5) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.animationTimeInterval = animationTimeInterval
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                Circle()
                    .foregroundColor(self.backgroundColor)
                    .opacity(0.5)
                    .shadow(radius: 1)
                
                FilledLoadingCircle(radius: min(geometry.size.width, geometry.size.height)/2, progress: self.progress)
                    .fill(self.foregroundColor)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: self.animationTimeInterval))
            }
        }
    }
}

fileprivate struct FilledLoadingCircle: Shape {
    
    var radius: CGFloat
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(0), endAngle: .degrees(Double(progress) * 360), clockwise: false)
        return path
    }
}


struct FilledCircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        FilledCircleProgress(progress: 0.3)
    }
}
