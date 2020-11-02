//
//  ArcProgress.swift
//  ProgressView
//
//  Created by funway on 2020/7/31.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct ArcProgress: View {
    var progress: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var lineWidth: CGFloat
    var animationTimeInterval: TimeInterval
    var clockwise: Bool
    
    public init(progress: CGFloat, backgroundColor : Color = .gray, foregroundColor: Color = .pink,
                lineWidth: CGFloat = 10, animationTimeInterval: TimeInterval = 0.5, clockwise: Bool = true) {
        self.progress = progress
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.lineWidth = lineWidth
        self.animationTimeInterval = animationTimeInterval
        self.clockwise = clockwise
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Arc(startAngle: .degrees(-90), endAngle: .degrees(90))
                    .strokeBorder(self.backgroundColor, lineWidth: self.lineWidth)
                    .aspectRatio(contentMode: .fill)
                    .shadow(radius: 1)
                    .opacity(0.2)
                    .position(x: geometry.size.width/2, y: geometry.size.height)
                
                Arc(startAngle: self.clockwise ? .degrees(-90) : .degrees(90 - 180*Double(min(self.progress, 1))), endAngle: self.clockwise ? Angle.degrees(180*Double(min(self.progress, 1))-90) : .degrees(90))
                    .strokeBorder(self.foregroundColor, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round))
                    .position(x: geometry.size.width/2, y: geometry.size.height)
                    .animation(.linear(duration: self.animationTimeInterval))
            }
        }
    }
}


fileprivate struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var insetAmount: CGFloat = 0
        
    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(startAngle.animatableData, endAngle.animatableData)
        }

        set {
            self.startAngle.animatableData = newValue.first
            self.endAngle.animatableData = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: false)

        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}




struct ArcProgress_Previews: PreviewProvider {
    static var previews: some View {
        ArcProgress(progress: 0.1, clockwise: false).frame(width: 300, height: 200)
    }
}
