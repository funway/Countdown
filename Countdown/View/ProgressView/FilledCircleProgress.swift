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
    var clockwise: Bool
    
    public init(progress: CGFloat, backgroundColor : Color = .secondary, foregroundColor: Color = .pink,
                animationTimeInterval: TimeInterval = 0.5, clockwise: Bool = true) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.animationTimeInterval = animationTimeInterval
        self.clockwise = clockwise
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                Circle()
                    .foregroundColor(self.backgroundColor)
                    .opacity(0.2)
                    .shadow(radius: 1)
                
                FilledLoadingCircle(radius: min(geometry.size.width, geometry.size.height)/2, progress: self.progress, clockwise: self.clockwise)
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
    var clockwise: Bool
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: clockwise ? .degrees(0) : .degrees(Double(1-progress) * 360), endAngle: clockwise ? .degrees(Double(progress) * 360) : .degrees(360), clockwise: false)
        return path
    }
}


struct FilledCircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        FilledCircleProgress(progress: 0.3)
    }
}
